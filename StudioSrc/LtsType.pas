unit LtsType;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015 - 2016                                  *)
(*                                                                            *)
(* Section Desc: Main type definitions                                        *)
(*                                                                            *)
(*============================================================================*)

interface

uses
  Windows, SysUtils, Classes;

type

  PThemeFile = ^TThemeFile;
  TThemeFile = record
    Name: string;
    Path: string;
    Data: TMemoryStream;
  end;
  TThemeFiles = array of TThemeFile;

  TItemRescKind = (rkDir, rkFile);

  TFileResc = record
    Name: string;
    Path: string;
    Kind: TItemRescKind;
    Data: TStream;
  end;
  PFileResc = ^TFileResc;

  (* Additional - Editor List *)
  TPicEditor= record
    AppName: string;
    AppPath: string;
    CommandLine: string;
    AdvancedDragDrop: Boolean;
    WindowName: string;
    WindowClass: string;
  end;


implementation

end.
