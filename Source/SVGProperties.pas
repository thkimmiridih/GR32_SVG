      {******************************************************************}
      { Parse of SVG properties                                          }
      {                                                                  }
      { home page : http://www.mwcs.de                                   }
      { email     : martin.walter@mwcs.de                                }
      {                                                                  }
      { date      : 05-04-2008                                           }
      {                                                                  }
      { Use of this file is permitted for commercial and non-commercial  }
      { use, as long as the author is credited.                          }
      { This file (c) 2005, 2008 Martin Walter                           }
      {                                                                  }
      { This Software is distributed on an "AS IS" basis, WITHOUT        }
      { WARRANTY OF ANY KIND, either express or implied.                 }
      {                                                                  }
      { *****************************************************************}

unit SVGProperties;

interface

uses
  //MSXML2_TLB_Light,
  OEncoding, OWideSupp, OTextReadWrite, OXmlReadWrite, OXmlUtils,
  OXmlCDOM, OXmlPDOM, OXmlSAX, OXmlSeq, OXmlSerialize,

  SVGTypes,
  GR32_Transforms

  //,Matrix
  ;

procedure LoadLength(const Node: PXMLNode; const S: WideString;
  var X: TFloat);

procedure LoadTFloat(const Node: PXMLNode; const S: WideString;
  var X: TFloat);

procedure LoadString(const Node: PXMLNode; const S: WideString;
  var X: WideString);

procedure LoadTransform(const Node: PXMLNode; const S: WideString;
  var Matrix: TFloatMatrix);

procedure LoadPercent(const Node: PXMLNode; const S: WideString;
  var X: TFloat); overload;
procedure LoadPercent(const Node: PXMLNode; const S: WideString;
  Max: Integer; var X: TFloat); overload;
procedure LoadBytePercent(const Node: PXMLNode; const S: WideString;
  var X: Integer);

procedure LoadBoolean(const Node: PXMLNode; const S: WideString;
  var X: Boolean);

procedure LoadDisplay(const Node: PXMLNode; var X: Integer);

procedure LoadVisible(const Node: PXMLNode; var X: Integer);

procedure LoadGradientUnits(const Node: PXMLNode; var Units: TGradientUnits);

implementation

uses
  SVGCommon, SVGParse;

procedure LoadLength(const Node: PXMLNode; const S: WideString;
  var X: TFloat);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := ParseLength(Attribute.nodeValue);
end;

procedure LoadTFloat(const Node: PXMLNode; const S: WideString;
  var X: TFloat);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := StrToTFloat(Attribute.nodeValue);
end;

procedure LoadString(const Node: PXMLNode; const S: WideString;
  var X: WideString);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := Attribute.nodeValue;
end;

procedure LoadTransform(const Node: PXMLNode; const S: WideString;
  var Matrix: TFloatMatrix);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    Matrix := ParseTransform(Attribute.nodeValue);
end;

procedure LoadPercent(const Node: PXMLNode; const S: WideString;
  var X: TFloat);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := ParsePercent(Attribute.nodeValue);
end;

procedure LoadPercent(const Node: PXMLNode; const S: WideString;
  Max: Integer; var X: TFloat);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := Max * ParsePercent(Attribute.nodeValue);
end;

procedure LoadBytePercent(const Node: PXMLNode; const S: WideString;
  var X: Integer);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := Round(255 * ParsePercent(Attribute.nodeValue));
end;

procedure LoadBoolean(const Node: PXMLNode; const S: WideString;
  var X: Boolean);
var
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode(S);
  if Assigned(Attribute) then
    X := Boolean(ParseInteger(Attribute.nodeValue));
end;

procedure LoadDisplay(const Node: PXMLNode; var X: Integer);
var
  S: WideString;
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode('display');
  if Assigned(Attribute) then
  begin
    S := Attribute.nodeValue;
    if S = 'inherit' then
      X := -1
    else
      if S = 'none' then
        X := 0
      else
        X := 1;
  end;
end;

procedure LoadVisible(const Node: PXMLNode; var X: Integer);
var
  S: WideString;
  Attribute: PXMLNode;
begin
  Attribute := Node.AttributeNodes.FindNode('visibility');
  if Assigned(Attribute) then
  begin
    S := Attribute.nodeValue;
    if S = 'inherit' then
      X := -1
    else
      if S = 'visible' then
        X := 1
      else
        X := 0;
  end;
end;

procedure LoadGradientUnits(const Node: PXMLNode; var Units: TGradientUnits);
var
  S: WideString;
  Attribute: PXMLNode;
begin
  Units := guObjectBoundingBox;
  Attribute := Node.AttributeNodes.FindNode('gradientUnits');
  if Assigned(Attribute) then
  begin
    S := Attribute.nodeValue;
    if S = 'userSpaceOnUse' then
      Units := guUserSpaceOnUse
    else
      if S = 'objectBoundingBox' then
        Units := guObjectBoundingBox;
  end;
end;

end.
