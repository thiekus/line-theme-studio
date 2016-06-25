unit JsonUtils;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015                                         *)
(*                                                                            *)
(* Section Desc: Json Utility                                                 *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  SysUtils, Classes, superobject, VirtualTrees;

type
  TValueKind = (vlNull,
                vlMainRoot,
                vlBool,
                vlInteger,
                vlFloat,
                vlObject,
                vlArray,
                vlString,
                vlColor,
                vlImage,
                vlPadding
  );

type
  PJsonNode = ^TJsonNode;
  TJsonNode = record
    Index : Integer;
    Name  : string;
    Kind  : TValueKind;
    Obj   : ISuperObject;
  end;

  function  GetValueKind(const Obj: ISuperObject): TValueKind;
  procedure SaveTreeToJson(Const Target: TStringList; Const Tree: TVirtualStringTree);

implementation

const
  IndentMul = 4;

function GetValueKind(const Obj: ISuperObject): TValueKind;
var
  eval: string;
  tmpk: TValueKind;
begin

  case ObjectGetType(Obj) of
    stNull              : tmpk:= vlNull;
    stBoolean           : tmpk:= vlBool;
    stInt               : tmpk:= vlInteger;
    stDouble, stCurrency: tmpk:= vlFloat;
    stObject            : tmpk:= vlObject;
    stArray             : tmpk:= vlArray;
  else
    eval:= UpperCase(Obj.AsString);
    tmpk:= vlString;
    if eval <> '' then
      begin
      if eval[1] = '#' then
        tmpk:= vlColor
      else
      if ExtractFileExt(eval) = '.PNG' then
        tmpk:= vlImage;
    end;
  end;
  Result:= tmpk;

end;

(* Our hacky Json regenerator :) *)
procedure SaveTreeToJson(Const Target: TStringList; Const Tree: TVirtualStringTree);
var
  jsondt: TStringList;

  function IndentSpc(Depth: integer): string; inline;
  var
    lvmul, lp: integer;
  begin
    Result:= '';
    lvmul:= Depth * IndentMul;
    for lp:= 1 to lvmul do
      Result:= Result + ' ';
  end;

var
  sbuf: string;
  zfra: integer;
  lvl, nlvl: integer;
  enode: PVirtualNode;
  data: PJsonNode;
  arritm: string;
begin

  jsondt:= TStringList.Create;
  try
    jsondt.Clear;
    jsondt.Add('{');
    try
      enode:= Tree.GetFirstNoInit();
      data:= Tree.GetNodeData(enode);
      if data^.Kind = vlMainRoot then
        enode:= Tree.GetNextNoInit(enode);
      lvl:= Tree.GetNodeLevel(enode);
      while Assigned(enode) do
        begin
        data:= Tree.GetNodeData(enode);
        if data^.Kind <> vlMainRoot then
          case ObjectGetType(data^.Obj) of
            stObject: sbuf:= Format('%s"%s": {', [IndentSpc(lvl), data^.Name]);
            stString: sbuf:= Format('%s"%s": "%s"', [IndentSpc(lvl), data^.Name, data^.Obj.AsString]);
            stArray : begin
                        arritm:= '';
                        for zfra:= 0 to data^.Obj.AsArray.Length - 1 do
                          begin
                          enode:= Tree.GetNextNoInit(enode);
                          if zfra > 0 then
                            arritm:= arritm + ', ';
                          if ObjectGetType(data^.Obj.AsArray[zfra]) = stString then
                            arritm:= arritm + Format('"%s"', [data^.Obj.AsArray.S[zfra]])
                          else
                            arritm:= arritm + data^.Obj.AsArray.S[zfra];
                        end;
                        sbuf:= Format('%s"%s": [%s]', [IndentSpc(lvl), data^.Name, arritm]);
                      end;
          else
            sbuf:= Format('%s"%s": %s', [IndentSpc(lvl), data^.Name, data^.Obj.AsJSon(TRUE, FALSE)]);
          end;
        enode:= Tree.GetNextNoInit(enode);
        if Assigned(enode) then
          begin
          nlvl:= Tree.GetNodeLevel(enode);
          if (lvl = nlvl) then
            sbuf:= sbuf + ',';
        end
        else
          nlvl:= 1;
        (**)
        jsondt.Add(sbuf);
        while lvl > nlvl do
          begin
          Dec(lvl);
          if (lvl = nlvl) and Assigned(enode) then
            jsondt.Add(IndentSpc(lvl)+'},')
          else
            jsondt.Add(IndentSpc(lvl)+'}');
        end;
        lvl:= nlvl;
      end;
    finally
      jsondt.Add('}');
      Target.AddStrings(jsondt);
    end;
  finally
    jsondt.Free;
  end;

end;

end.
