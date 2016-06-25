unit ResGraphic;

(*============================================================================*)
(*                                                                            *)
(* Line Theme Studio (Codename SodaPoppers)                                   *)
(* Coded by Faris Khowarizmi (thekill96*at*gmail.com)                         *)
(* Copyright © Khayalan Software 2015 - 2016                                  *)
(*                                                                            *)
(* Section Desc: Graphic utils module                                         *)
(*============================================================================*)


interface

uses
  SysUtils, Classes, Graphics, Imaging, ImagingTypes, ImagingComponents;

  function ImportPicture(var DestStream: TStream; const Path: string): boolean;

implementation

function ImportPicture(var DestStream: TStream; const Path: string): boolean;
var
  png: TImagingPNG;
  img: TImagingGraphic;
begin

  Result:= True;
  try
    img:= TImagingGraphic.Create;
    try

      img.LoadFromFile(Path);
      png:= TImagingPNG.Create;
      try
        png.Assign(img);
        DestStream.Size:= 0;
        DestStream.Position:= 0;
        png.SaveToStream(DestStream);
      finally
        png.Free;
      end;

    finally
      img.Free;
    end;
  except
    Result:= False;
  end;

end;

end.
