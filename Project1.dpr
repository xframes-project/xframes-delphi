program XFrames;

uses
  System.SysUtils,
  System.Classes,
  System.Generics.Collections,
  Math,
  System.JSON;

const
  ImGuiCol_Text = 0;
  ImGuiCol_TextDisabled = 1;
  ImGuiCol_WindowBg = 2;
  ImGuiCol_ChildBg = 3;
  ImGuiCol_PopupBg = 4;
  ImGuiCol_Border = 5;
  ImGuiCol_BorderShadow = 6;
  ImGuiCol_FrameBg = 7;
  ImGuiCol_FrameBgHovered = 8;
  ImGuiCol_FrameBgActive = 9;
  ImGuiCol_TitleBg = 10;
  ImGuiCol_TitleBgActive = 11;
  ImGuiCol_TitleBgCollapsed = 12;
  ImGuiCol_MenuBarBg = 13;
  ImGuiCol_ScrollbarBg = 14;
  ImGuiCol_ScrollbarGrab = 15;
  ImGuiCol_ScrollbarGrabHovered = 16;
  ImGuiCol_ScrollbarGrabActive = 17;
  ImGuiCol_CheckMark = 18;
  ImGuiCol_SliderGrab = 19;
  ImGuiCol_SliderGrabActive = 20;
  ImGuiCol_Button = 21;
  ImGuiCol_ButtonHovered = 22;
  ImGuiCol_ButtonActive = 23;
  ImGuiCol_Header = 24;
  ImGuiCol_HeaderHovered = 25;
  ImGuiCol_HeaderActive = 26;
  ImGuiCol_Separator = 27;
  ImGuiCol_SeparatorHovered = 28;
  ImGuiCol_SeparatorActive = 29;
  ImGuiCol_ResizeGrip = 30;
  ImGuiCol_ResizeGripHovered = 31;
  ImGuiCol_ResizeGripActive = 32;
  ImGuiCol_Tab = 33;
  ImGuiCol_TabHovered = 34;
  ImGuiCol_TabActive = 35;
  ImGuiCol_TabUnfocused = 36;
  ImGuiCol_TabUnfocusedActive = 37;
  ImGuiCol_PlotLines = 38;
  ImGuiCol_PlotLinesHovered = 39;
  ImGuiCol_PlotHistogram = 40;
  ImGuiCol_PlotHistogramHovered = 41;
  ImGuiCol_TableHeaderBg = 42;
  ImGuiCol_TableBorderStrong = 43;
  ImGuiCol_TableBorderLight = 44;
  ImGuiCol_TableRowBg = 45;
  ImGuiCol_TableRowBgAlt = 46;
  ImGuiCol_TextSelectedBg = 47;
  ImGuiCol_DragDropTarget = 48;
  ImGuiCol_NavHighlight = 49;
  ImGuiCol_NavWindowingHighlight = 50;
  ImGuiCol_NavWindowingDimBg = 51;
  ImGuiCol_ModalWindowDimBg = 52;


// Record definitions

type
  TFontDef = record
    Name: string;
    Size: Integer;
  end;

  THEXA = record
    Color: string;
    Alpha: Double;
  end;

function CreateTHEXA(AColor: string; AAlpha: Double): THEXA;
begin
  Result.Color := AColor;
  Result.Alpha := AAlpha;
end;


// Callback types

type
  TOnInitCb = procedure; cdecl;
  TOnTextChangedCb = procedure(ID: Integer; Text: PAnsiChar); cdecl;
  TOnComboChangedCb = procedure(ID: Integer; Index: Integer); cdecl;
  TOnNumericValueChangedCb = procedure(ID: Integer; Value: Single); cdecl;
  TOnBooleanValueChangedCb = procedure(ID: Integer; Value: Boolean); cdecl;
  TOnMultipleNumericValuesChangedCb = procedure(ID: Integer; Values: PSingle; NumValues: Integer); cdecl;
  TOnClickCb = procedure(ID: Integer); cdecl;


// External DLL procedures

procedure Init(
  AssetsBasePath: PAnsiChar;
  RawFontDefinitions: PAnsiChar;
  RawStyleOverrideDefinitions: PAnsiChar;
  OnInit: TOnInitCb;
  OnTextChanged: TOnTextChangedCb;
  OnComboChanged: TOnComboChangedCb;
  OnNumericValueChanged: TOnNumericValueChangedCb;
  OnBooleanValueChanged: TOnBooleanValueChangedCb;
  OnMultipleNumericValuesChanged: TOnMultipleNumericValuesChangedCb;
  OnClick: TOnClickCb
); cdecl; external 'xframesshared.dll';

procedure SetElement(ElementJson: PAnsiChar); cdecl; external 'xframesshared.dll';
procedure SetChildren(ID: Integer; ChildrenIDs: PAnsiChar); cdecl; external 'xframesshared.dll';


// Callback implementations

procedure MyOnInit; cdecl;
var
  RootNode, UnformattedText: TJSONObject;
  ChildrenIDs: TJSONArray;
begin
  RootNode := TJSONObject.Create;
  try
    RootNode.AddPair('type', 'node');
    RootNode.AddPair('id', TJSONNumber.Create(0));
    RootNode.AddPair('root', TJSONBool.Create(True));

    UnformattedText := TJSONObject.Create;
    try
      UnformattedText.AddPair('type', 'unformatted-text');
      UnformattedText.AddPair('id', TJSONNumber.Create(1));
      UnformattedText.AddPair('text', 'Hello, world');

      ChildrenIDs := TJSONArray.Create;
      try
        ChildrenIDs.Add(1);

        SetElement(PAnsiChar(AnsiString(RootNode.ToJSON)));  // Convert to PAnsiChar
        SetElement(PAnsiChar(AnsiString(UnformattedText.ToJSON)));
        SetChildren(0, PAnsiChar(AnsiString(ChildrenIDs.ToJSON)));
      finally
        ChildrenIDs.Free;
      end;
    finally
      UnformattedText.Free;
    end;
  finally
    RootNode.Free;
  end;
end;


procedure MyOnTextChanged(ID: Integer; Text: PAnsiChar); cdecl;
begin
  Writeln('Text changed: ID = ', ID, ', Text = ', Text);
end;

procedure MyOnComboChanged(ID: Integer; Index: Integer); cdecl;
begin
  Writeln('Combo changed: ID = ', ID, ', Index = ', Index);
end;

procedure MyOnNumericValueChanged(ID: Integer; Value: Single); cdecl;
begin
  Writeln('Numeric value changed: ID = ', ID, ', Value = ', Value:0:2);
end;

procedure MyOnBooleanValueChanged(ID: Integer; Value: Boolean); cdecl;
begin
  Writeln('Boolean value changed: ID = ', ID, ', Value = ', Value);
end;

procedure MyOnMultipleNumericValuesChanged(ID: Integer; Values: PSingle; NumValues: Integer); cdecl;
var
  I: Integer;
begin
  Write('Multiple numeric values changed: ID = ', ID, ', Values = ');
end;

procedure MyOnClick(ID: Integer); cdecl;
begin
  Writeln('Click event: ID = ', ID);
end;


// Main program

var
  ThemeDef, ColorDefs, FontDef, FontDefs: TJSONObject;
  DefsArray: TJSONArray;
  FontDefArray: array of TFontDef;
  FontSizes: array of Integer;
  Theme2Colors: TStringList;
  Theme2: TDictionary<Integer, THEXA>;
  HEXAJsonArray: TJSONArray;
  I: Integer;

begin
    Theme2Colors := TStringList.Create;
    Theme2 := TDictionary<Integer, THEXA>.Create;
    ThemeDef := TJSONObject.Create;
    ColorDefs := TJSONObject.Create;
    FontSizes := [16, 18, 20, 24, 28, 32, 36, 48];

    // Add colors
    Theme2Colors.Add('darkestGrey=#141f2c');
    Theme2Colors.Add('darkerGrey=#2a2e39');
    Theme2Colors.Add('darkGrey=#363b4a');
    Theme2Colors.Add('lightGrey=#5a5a5a');
    Theme2Colors.Add('lighterGrey=#7A818C');
    Theme2Colors.Add('evenLighterGrey=#8491a3');
    Theme2Colors.Add('black=#0A0B0D');
    Theme2Colors.Add('green=#75f986');
    Theme2Colors.Add('red=#ff0062');
    Theme2Colors.Add('white=#fff');

    Theme2.Add(ImGuiCol_Text, CreateTHEXA(Theme2Colors.Values['white'], 1.0));
    Theme2.Add(ImGuiCol_TextDisabled, CreateTHEXA(Theme2Colors.Values['lighterGrey'], 1));
    Theme2.Add(ImGuiCol_WindowBg, CreateTHEXA(Theme2Colors.Values['black'], 1));
    Theme2.Add(ImGuiCol_ChildBg, CreateTHEXA(Theme2Colors.Values['black'], 1));
    Theme2.Add(ImGuiCol_PopupBg, CreateTHEXA(Theme2Colors.Values['white'], 1));
    Theme2.Add(ImGuiCol_Border, CreateTHEXA(Theme2Colors.Values['lightGrey'], 1));
    Theme2.Add(ImGuiCol_BorderShadow, CreateTHEXA(Theme2Colors.Values['darkestGrey'], 1));

    for I := 0 to Theme2.Count - 1 do
    begin
      HEXAJsonArray := TJSONArray.Create;
      HEXAJsonArray.Add(Theme2.Items[Theme2.Keys.ToArray[I]].Color);
      HEXAJsonArray.Add(Theme2.Items[Theme2.Keys.ToArray[I]].Alpha);
      ColorDefs.AddPair(IntToStr(Theme2.Keys.ToArray[I]), HEXAJsonArray);
    end;

    ThemeDef.AddPair('colors', ColorDefs);

    SetLength(FontDefArray, Length(FontSizes));
    for I := 0 to High(FontSizes) do
    begin
      FontDefArray[I].Name := 'roboto-regular';
      FontDefArray[I].Size := FontSizes[I];
    end;

    FontDefs := TJSONObject.Create;
    DefsArray := TJSONArray.Create;

    for I := 0 to High(FontDefArray) do
    begin
      FontDef := TJSONObject.Create;
      FontDef.AddPair('name', FontDefArray[I].Name);
      FontDef.AddPair('size', TJSONNumber.Create(FontDefArray[I].Size));
      DefsArray.AddElement(FontDef);
    end;

    FontDefs.AddPair('defs', DefsArray);

    Init(
      PAnsiChar(AnsiString('./assets')),
      PAnsiChar(AnsiString(FontDefs.ToJSON)),
      PAnsiChar(AnsiString(ThemeDef.ToJSON)),
      @MyOnInit,
      @MyOnTextChanged,
      @MyOnComboChanged,
      @MyOnNumericValueChanged,
      @MyOnBooleanValueChanged,
      @MyOnMultipleNumericValuesChanged,
      @MyOnClick
    );

    Writeln('Press CTRL+C to exit.');

    while True do
    begin
      Sleep(1000)
    end
  end
.
