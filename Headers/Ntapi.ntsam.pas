unit Ntapi.ntsam;

interface
{$MINENUMSIZE 4}

uses
  Winapi.WinNt, Ntapi.ntdef;

const
  samlib = 'samlib.dll';

  MAX_PREFERRED_LENGTH = MaxInt;

  // 158
  SAM_SERVER_CONNECT = $0001;
  SAM_SERVER_SHUTDOWN = $0002;
  SAM_SERVER_INITIALIZE = $0004;
  SAM_SERVER_CREATE_DOMAIN = $0008;
  SAM_SERVER_ENUMERATE_DOMAINS = $0010;
  SAM_SERVER_LOOKUP_DOMAIN = $0020;

  // 202
  DOMAIN_READ_PASSWORD_PARAMETERS = $0001;
  DOMAIN_WRITE_PASSWORD_PARAMS = $0002;
  DOMAIN_READ_OTHER_PARAMETERS = $0004;
  DOMAIN_WRITE_OTHER_PARAMETERS = $0008;
  DOMAIN_CREATE_USER = $0010;
  DOMAIN_CREATE_GROUP = $0020;
  DOMAIN_CREATE_ALIAS = $0040;
  DOMAIN_GET_ALIAS_MEMBERSHIP = $0080;
  DOMAIN_LIST_ACCOUNTS = $0100;
  DOMAIN_LOOKUP = $0200;
  DOMAIN_ADMINISTER_SERVER = $0400;

  // 528
  GROUP_READ_INFORMATION = $0001;
  GROUP_WRITE_ACCOUNT = $0002;
  GROUP_ADD_MEMBER = $0004;
  GROUP_REMOVE_MEMBER = $0008;
  GROUP_LIST_MEMBERS = $0010;

  // 604
  ALIAS_ADD_MEMBER = $0001;
  ALIAS_REMOVE_MEMBER = $0002;
  ALIAS_LIST_MEMBERS = $0004;
  ALIAS_READ_INFORMATION = $0008;
  ALIAS_WRITE_ACCOUNT = $0010;

  // 706
  USER_READ_GENERAL = $0001;
  USER_READ_PREFERENCES = $0002;
  USER_WRITE_PREFERENCES = $0004;
  USER_READ_LOGON = $0008;
  USER_READ_ACCOUNT = $0010;
  USER_WRITE_ACCOUNT = $0020;
  USER_CHANGE_PASSWORD = $0040;
  USER_FORCE_PASSWORD_CHANGE = $0080;
  USER_LIST_GROUPS = $0100;
  USER_READ_GROUP_INFORMATION = $0200;
  USER_WRITE_GROUP_INFORMATION = $0400;

type
  TSamHandle = NativeUInt;

  TSamEnumerationHandle = Cardinal;

  // 77
  TSamRidEnumeration = record
    RelativeId: Cardinal;
    Name: UNICODE_STRING;
  end;
  PSamRidEnumeration = ^TSamRidEnumeration;

  TSamRidEnumerationArray = array [Word] of TSamRidEnumeration;
  PSamRidEnumerationArray = ^TSamRidEnumerationArray;

  // 82
  TSamSidEnumeration = record
    Sid: PSid;
    Name: UNICODE_STRING;
  end;
  PSamSidEnumeration = ^TSamSidEnumeration;

  TSamSidEnumerationArray = array [Word] of TSamSidEnumeration;
  PSamSidEnumerationArray = ^TSamSidEnumerationArray;

  TCardinalArray = array [Word] of Cardinal;
  PCardinalArray = ^TCardinalArray;

  // 263
  TDomainInformationClass = (
    DomainPasswordInformation = 1,    // q, s:
    DomainGeneralInformation = 2,     // q: TDomainGeneralInformation
    DomainLogoffInformation = 3,      // q, s: TLargeInteger
    DomainOemInformation = 4,         // q, s: UNICODE_STRING
    DomainNameInformation = 5,        // q: UNICODE_STRING
    DomainReplicationInformation = 6, // q, s: UNICODE_STRING
    DomainServerRoleInformation = 7,  // q, s: TDomainServerRole
    DomainModifiedInformation = 8,    // q: TDomainModifiedInformation
    DomainStateInformation = 9,       // q, s: TDomainServerEnableState
    DomainUasInformation = 10,        // q, s: Boolean
    DomainGeneralInformation2 = 11,   // q:
    DomainLockoutInformation = 12,    // q, s:
    DomainModifiedInformation2 = 13   // q:
  );

  // 279
  TDomainServerEnableState = (
    DomainServerEnabled = 1,
    DomainServerDisabled
  );

  // 284
  TDomainServerRole = (
    DomainServerRoleBackup = 2,
    DomainServerRolePrimary
  );

  // 290
  TDomainGeneralInformation = record
    ForceLogoff: TLargeInteger;
    OemInformation: UNICODE_STRING;
    DomainName: UNICODE_STRING;
    ReplicaSourceNodeName: UNICODE_STRING;
    DomainModifiedCount: Int64;
    DomainServerState: TDomainServerEnableState;
    DomainServerRole: TDomainServerRole;
    UasCompatibilityRequired: Boolean;
    UserCount: Cardinal;
    GroupCount: Cardinal;
    AliasCount: Cardinal;
  end;

  // 394
  TDomainModifiedInformation = record
    DomainModifiedCount: Int64;
    CreationTime: TLargeInteger;
  end;
  PDomainModifiedInformation = ^TDomainModifiedInformation;

  // 565
  TGroupInfrmationClass = (
    GroupGeneralInformation = 1,     // q: TGroupGeneralInformation
    GroupNameInformation = 2,        // q, s: UNICODE_STRING;
    GroupAttributeInformation = 3,   // q, s: Cardinal
    GroupAdminCommentInformation = 4 // q, s: UNICODE_STRING;
  );

  // 573
  TGroupGeneralInformation = record
    Name: UNICODE_STRING;
    Attributes: Cardinal;
    MemberCount: Cardinal;
    AdminComment: UNICODE_STRING;
  end;
  PGroupGeneralInformation = ^TGroupGeneralInformation;

  // 634
  TAliasInformationClass = (
    AliasGeneralInformation = 1,      // q: TAliasGeneralInformation
    AliasNameInformation = 2,         // q, s: UNICODE_STRING
    AliasAdminCommentInformation = 3, // q, s: UNICODE_STRING
    AliasReplicationInformation = 4,  // q: UNICODE_STRING
    AliasExtendedInformation = 5      // q, s:
  );

  // 642
  TAliasGeneralInformation = record
    Name: UNICODE_STRING;
    MemberCount: Cardinal;
    AdminComment: UNICODE_STRING;
  end;
  PAliasGeneralInformation = ^TAliasGeneralInformation;

  // 829
  TLogonHours = record
    UnitsPerWeek: Word;
    LogonHours: PByte;
  end;

  // 860
  TUserInformationClass = (
    UserGeneralInformation = 1,       // q: TUserGeneralInformation
    UserPreferencesInformation = 2,   // q, s:
    UserLogonInformation = 3,         // q: TUserLogonInformation
    UserLogonHoursInformation = 4,    // q, s: TLogonHours
    UserAccountInformation = 5,       // q: TUserAccountInformation (almost identical to TUserLogonInformation)
    UserNameInformation = 6,          // q, s:
    UserAccountNameInformation = 7,   // q, s: UNICODE_STRING
    UserFullNameInformation = 8,      // q, s: UNICODE_STRING
    UserPrimaryGroupInformation = 9,  // q, s: Cardinal
    UserHomeInformation = 10,         // q, s:
    UserScriptInformation = 11,       // q, s: UNICODE_STRING
    UserProfileInformation = 12,      // q, s: UNICODE_STRING
    UserAdminCommentInformation = 13, // q, s: UNICODE_STRING
    UserWorkStationsInformation = 14, // q, s:
    UserSetPasswordInformation = 15,  // s:
    UserControlInformation = 16,      // q, s: Cardinal
    UserExpiresInformation = 17,      // q, s: TLargeInteger
    UserInternal1Information = 18,    // q, s:
    UserInternal2Information = 19,    // q, s:
    UserParametersInformation = 20,   // q, s: UNICODE_STRING
    UserAllInformation = 21,          // q, s:
    UserInternal3Information = 22,    // q, s:
    UserInternal4Information = 23,    // s:
    UserInternal5Information = 24,    // s:
    UserInternal4InformationNew = 25, // s:
    UserInternal5InformationNew = 26, // s:
    UserInternal6Information = 27,    // q, s:
    UserExtendedInformation = 28,     // q, s:
    UserLogonUIInformation = 29       // q:
  );

  // 1105
  TUserGeneralInformation = record
    UserName: UNICODE_STRING;
    FullName: UNICODE_STRING;
    PrimaryGroupId: Cardinal;
    AdminComment: UNICODE_STRING;
    UserComment: UNICODE_STRING;
  end;
  PUserGeneralInformation = ^TUserGeneralInformation;

  // 1125
  TUserLogonInformation = record
    UserName: UNICODE_STRING;
    FullName: UNICODE_STRING;
    UserId: Cardinal;
    PrimaryGroupId: Cardinal;
    HomeDirectory: UNICODE_STRING;
    HomeDirectoryDrive: UNICODE_STRING;
    ScriptPath: UNICODE_STRING;
    ProfilePath: UNICODE_STRING;
    WorkStations: UNICODE_STRING;
    LastLogon: TLargeInteger;
    LastLogoff: TLargeInteger;
    PasswordLastSet: TLargeInteger;
    PasswordCanChange: TLargeInteger;
    PasswordMustChange: TLargeInteger;
    LogonHours: TLogonHours;
    BadPasswordCount: Word;
    LogonCount: Word;
    UserAccountControl: Cardinal;
  end;
  PUserLogonInformation = ^TUserLogonInformation;

// 1777
function SamFreeMemory(Buffer: Pointer): NTSTATUS; stdcall; external samlib;

// 1799
function SamCloseHandle(SamHandle: TSamHandle): NTSTATUS; stdcall;
  external samlib;

// 1805
function SamConnect(ServerName: PUNICODE_STRING; out ServerHandle: TSamHandle;
  DesiredAccess: TAccessMask; const ObjectAttributes: TObjectAttributes):
  NTSTATUS; stdcall; external samlib;

// 1820
function SamLookupDomainInSamServer(ServerHandle: TSamHandle;
  const Name: UNICODE_STRING; out DomainId: PSid): NTSTATUS; stdcall;
  external samlib;

// 1828
function SamEnumerateDomainsInSamServer(ServerHandle: TSamHandle;
  var EnumerationContext: TSamEnumerationHandle;
  out Buffer: PSamRidEnumerationArray; PreferedMaximumLength: Integer;
  out CountReturned: Integer): NTSTATUS; stdcall; external samlib;

// 1838
function SamOpenDomain(ServerHandle: TSamHandle; DesiredAccess: TAccessMask;
  DomainId: PSid; out DomainHandle: TSamHandle): NTSTATUS; stdcall;
  external samlib;

// 1847
function SamQueryInformationDomain(DomainHandle: TSamHandle;
  DomainInformationClass: TDomainInformationClass; out Buffer: Pointer):
  NTSTATUS; stdcall; external samlib;

// 1855
function SamSetInformationDomain(DomainHandle: TSamHandle;
  DomainInformationClass: TDomainInformationClass; DomainInformation: Pointer):
  NTSTATUS; stdcall; external samlib;

// 1874
function SamEnumerateGroupsInDomain(DomainHandle: TSamHandle;
  var EnumerationContext: TSamEnumerationHandle;
  out Buffer: PSamRidEnumerationArray; PreferedMaximumLength: Integer;
  out CountReturned: Integer): NTSTATUS; stdcall; external samlib;

// 1906
function SamEnumerateUsersInDomain(DomainHandle: TSamHandle;
  var EnumerationContext: TSamEnumerationHandle; UserAccountControl: Cardinal;
  out Buffer: PSamRidEnumerationArray; PreferedMaximumLength: Integer;
  out CountReturned: Integer): NTSTATUS; stdcall; external samlib;

// 1929
function SamEnumerateAliasesInDomain(DomainHandle: TSamHandle;
  var EnumerationContext: TSamEnumerationHandle;
  out Buffer: PSamRidEnumerationArray; PreferedMaximumLength: Integer;
  out CountReturned: Integer): NTSTATUS; stdcall; external samlib;

// 1967
function SamOpenGroup(DomainHandle: TSamHandle; DesiredAccess: TAccessMask;
  GroupId: Cardinal; out GroupHandle: TSamHandle): NTSTATUS; stdcall;
  external samlib;

// 1976
function SamQueryInformationGroup(GroupHandle: TSamHandle;
  GroupInformationClass: TGroupGeneralInformation;
  out Buffer: Pointer): NTSTATUS; stdcall; external samlib;

// 1984
function SamSetInformationGroup(GroupHandle: TSamHandle;
  GroupInformationClass: TGroupInfrmationClass; Buffer: Pointer): NTSTATUS;
  stdcall; external samlib;

// 2013
function SamGetMembersInGroup(GroupHandle: TSamHandle;
  out MemberIds: PCardinalArray; out Attributes: PCardinalArray;
  out MemberCount: Cardinal): NTSTATUS; stdcall; external samlib;

// 2030
function SamOpenAlias(DomainHandle: TSamHandle; DesiredAccess: TAccessMask;
  AliasId: Cardinal; out AliasHandle: TSamHandle): NTSTATUS; stdcall;
  external samlib;

// 2039
function SamQueryInformationAlias(AliasHandle: TSamHandle;
  AliasInformationClass: TAliasInformationClass; out Buffer: Pointer): NTSTATUS;
  stdcall; external samlib;

// 2047
function SamSetInformationAlias(AliasHandle: TSamHandle;
  AliasInformationClass: TAliasInformationClass; Buffer: Pointer): NTSTATUS;
  stdcall; external samlib;

// 2098
function SamGetMembersInAlias(AliasHandle: TSamHandle; out MemberIds: PSidArray;
  out MemberCount: Cardinal): NTSTATUS; stdcall; external samlib;

// 2106
function SamOpenUser(DomainHandle: TSamHandle; DesiredAccess: TAccessMask;
  UserId: Cardinal; out UserHandle: TSamHandle): NTSTATUS; stdcall;
  external samlib;

// 2121
function SamQueryInformationUser(UserHandle: TSamHandle;
  UserInformationClass: TUserInformationClass; out Buffer: Pointer): NTSTATUS;
  stdcall; external samlib;

// 2129
function SamSetInformationUser(UserHandle: TSamHandle;
  UserInformationClass: TUserInformationClass; Buffer: Pointer): NTSTATUS;
  stdcall; external samlib;

// 2198
function SamRidToSid(ObjectHandle: TSamHandle; Rid: Cardinal;
  out Sid: PSid): NTSTATUS; stdcall; external samlib;

implementation

end.