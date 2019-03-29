unit Ntapi.ntdef;
{$MINENUMSIZE 4}

interface

uses
  Winapi.WinNt;

type
  NTSTATUS = Cardinal;
  KPRIORITY = Integer;

  ANSI_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PAnsiChar;
    procedure FromString(Value: AnsiString);
  end;
  PANSI_STRING = ^ANSI_STRING;

  UNICODE_STRING = record
    Length: Word;
    MaximumLength: Word;
    Buffer: PWideChar;
    function ToString: String;
    procedure FromString(Value: string);
  end;
  PUNICODE_STRING = ^UNICODE_STRING;

  TObjectAttributes = record
    Length: Cardinal;
    RootDirectory: THandle;
    ObjectName: PUNICODE_STRING;
    Attributes: Cardinal;
    SecurityDescriptor: PSecurityDescriptor;
    SecurityQualityOfService: PSecurityQualityOfService;
  end;
  PObjectAttributes = ^TObjectAttributes;

  TClientId = record
    UniqueProcess: NativeUInt;
    UniqueThread: NativeUInt;
    procedure Create(PID, TID: NativeUInt); inline;
  end;
  PClientId = ^TClientId;

const
  ntdll = 'ntdll.dll';

  OBJ_PROTECT_CLOSE = $00000001;
  OBJ_INHERIT = $00000002;
  OBJ_AUDIT_OBJECT_CLOSE = $00000004;
  OBJ_PERMANENT = $00000010;
  OBJ_EXCLUSIVE = $00000020;
  OBJ_CASE_INSENSITIVE = $00000040;
  OBJ_OPENIF  = $00000080;
  OBJ_OPENLINK  = $00000100;
  OBJ_KERNEL_HANDLE = $00000200;
  OBJ_FORCE_ACCESS_CHECK = $00000400;
  OBJ_IGNORE_IMPERSONATED_DEVICEMAP = $00000800;
  OBJ_DONT_REPARSE = $00001000;

function NT_SUCCESS(Status: NTSTATUS): Boolean; inline;
function NT_INFORMATION(Status: NTSTATUS): Boolean; inline;
function NT_WARNING(Status: NTSTATUS): Boolean; inline;
function NT_ERROR(Status: NTSTATUS): Boolean; inline;

procedure InitializeObjectAttributes(var ObjAttr: TObjectAttributes;
  ObjectName: PUNICODE_STRING = nil; Attributes: Cardinal = 0;
  RootDirectory: THandle = 0; QoS: PSecurityQualityOfService = nil); inline;

procedure InitializaQoS(var QoS: TSecurityQualityOfService;
  ImpersonationLevel: TSecurityImpersonationLevel = SecurityImpersonation;
  EffectiveOnly: Boolean = False); inline;

implementation

uses
  Ntapi.ntstatus;

function NT_SUCCESS(Status: NTSTATUS): Boolean;
begin
  Result := Integer(Status) >= 0; // 00000000..7FFFFFFF
end;

function NT_INFORMATION(Status: NTSTATUS): Boolean;
begin
  Result := (Status shr 30) = 1; // 40000000..7FFFFFFF
end;

function NT_WARNING(Status: NTSTATUS): Boolean;
begin
  Result := (Status shr 30) = 2; // 80000000..BFFFFFFF
end;

function NT_ERROR(Status: NTSTATUS): Boolean;
begin
  Result := (Status shr 30) = 3; // C0000000..FFFFFFFF
end;

procedure InitializeObjectAttributes(var ObjAttr: TObjectAttributes;
  ObjectName: PUNICODE_STRING; Attributes: Cardinal; RootDirectory: THandle;
  QoS: PSecurityQualityOfService);
begin
  FillChar(ObjAttr, SizeOf(ObjAttr), 0);
  ObjAttr.Length := SizeOf(ObjAttr);
  ObjAttr.ObjectName := ObjectName;
  ObjAttr.Attributes := Attributes;
  ObjAttr.RootDirectory := RootDirectory;
  ObjAttr.SecurityQualityOfService := QoS;
end;

procedure InitializaQoS(var QoS: TSecurityQualityOfService;
  ImpersonationLevel: TSecurityImpersonationLevel; EffectiveOnly: Boolean);
begin
  FillChar(QoS, SizeOf(QoS), 0);
  QoS.Length := SizeOf(QoS);
  QoS.ImpersonationLevel := ImpersonationLevel;
  QoS.EffectiveOnly := EffectiveOnly;
end;

{ ANSI_STRING }

procedure ANSI_STRING.FromString(Value: AnsiString);
begin
  Self.Buffer := PAnsiChar(Value);
  Self.Length := System.Length(Value) * SizeOf(AnsiChar);
  Self.MaximumLength := Self.Length + SizeOf(AnsiChar);
end;

{ UNICODE_STRING }

procedure UNICODE_STRING.FromString(Value: String);
begin
  Self.Buffer := PWideChar(Value);
  Self.Length := System.Length(Value) * SizeOf(WideChar);
  Self.MaximumLength := Self.Length + SizeOf(WideChar);
end;

function UNICODE_STRING.ToString: String;
begin
  SetString(Result, Buffer, Length div SizeOf(WideChar));
end;

{ TClientId }

procedure TClientId.Create(PID, TID: NativeUInt);
begin
  UniqueProcess := PID;
  UniqueThread := TID;
end;

end.
