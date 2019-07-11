﻿unit DelphiUtils.Strings;

interface

type
  TFlagName = record
    Value: Cardinal;
    Name: String;
  end;

function EnabledDisabledToString(Value: LongBool): String;
function YesNoToString(Value: LongBool): String;
function CheckboxToString(Value: LongBool): String;
function BytesToString(Size: Cardinal): String;

function Contains(Value, Flag: Cardinal): Boolean; inline;
function ContainsAny(Value, Flag: Cardinal): Boolean; inline;

function MapFlags(Value: Cardinal; Mapping: array of TFlagName): String;
function MapFlagsHint(Value: Cardinal; Mapping: array of TFlagName): String;

function IntToHexEx(Value: Int64; Digits: Integer = 0): String; overload;
function IntToHexEx(Value: UInt64; Digits: Integer = 0): String; overload;
function IntToHexEx(Value: Pointer): String; overload;

function TryStrToUInt64Ex(S: String; out Value: UInt64): Boolean;
function StrToUIntEx(S: String; Comment: String): Cardinal; inline;
function StrToUInt64Ex(S: String; Comment: String): UInt64; inline;

implementation

uses
  System.SysUtils;

function EnabledDisabledToString(Value: LongBool): String;
begin
  if Value then
    Result := 'Enabled'
  else
    Result := 'Disabled';
end;

function YesNoToString(Value: LongBool): String;
begin
  if Value then
    Result := 'Yes'
  else
    Result := 'No';
end;

function CheckboxToString(Value: LongBool): String;
begin
  if Value then
    Result := '☑'
  else
    Result := '☐';
end;

function BytesToString(Size: Cardinal): String;
begin
  if Size mod 1024 = 0 then
    Result := (Size div 1024).ToString + ' kB'
  else
    Result := Size.ToString + ' B';
end;

function Contains(Value, Flag: Cardinal): Boolean;
begin
  Result := (Value and Flag = Flag);
end;

function ContainsAny(Value, Flag: Cardinal): Boolean;
begin
  Result := (Value and Flag <> 0);
end;

function MapFlags(Value: Cardinal; Mapping: array of TFlagName): String;
var
  Strings: array of String;
  i, Count: Integer;
begin
  SetLength(Strings, Length(Mapping));

  Count := 0;
  for i := Low(Mapping) to High(Mapping) do
    if Contains(Value, Mapping[i].Value) then
    begin
      Strings[Count] := Mapping[i].Name;
      Inc(Count);
    end;

  SetLength(Strings, Count);
  Result := String.Join(', ', Strings);
end;

function MapFlagsHint(Value: Cardinal; Mapping: array of TFlagName): String;
var
  Strings: array of string;
  i: Integer;
begin
  SetLength(Strings, Length(Mapping));

  for i := Low(Mapping) to High(Mapping) do
    Strings[i - Low(Mapping)] := CheckboxToString(Contains(Value,
      Mapping[i].Value)) + ' ' + Mapping[i].Name;

  Result := String.Join(#$D#$A, Strings);
end;

function IntToHexEx(Value: UInt64; Digits: Integer): String;
begin
  Result := '0x' + IntToHex(Value, Digits);
end;

function IntToHexEx(Value: Int64; Digits: Integer): String;
begin
  Result := '0x' + IntToHex(Value, Digits);
end;

function IntToHexEx(Value: Pointer): String;
begin
  Result := '0x' + IntToHex(NativeUInt(Value), 8);
end;

function TryStrToUInt64Ex(S: String; out Value: UInt64): Boolean;
var
  E: Integer;
begin
  if S.StartsWith('0x') then
    S := S.Replace('0x', '$', []);

  Val(S, Value, E);
  Result := (E = 0);
end;

function StrToUInt64Ex(S: String; Comment: String): UInt64;
const
  E_DECHEX = 'Invalid %s. Please specify a decimal or a hexadecimal value.';
begin
  if not TryStrToUInt64Ex(S, Result) then
    raise EConvertError.Create(Format(E_DECHEX, [Comment]));
end;

function StrToUIntEx(S: String; Comment: String): Cardinal;
begin
  {$R-}
  Result := StrToUInt64Ex(S, Comment);
  {$R+}
end;

end.