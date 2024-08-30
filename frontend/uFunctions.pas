unit uFunctions;

interface

uses
  System.JSON, REST.Client, REST.Types, System.SysUtils, System.Classes,
  System.StrUtils, Dialogs;

type
  API = class
  private
    class function CreateReq(const ENDPOINT: String): TRESTRequest;

  public

    class function doReq(const Method: string = 'GET';
      const ENDPOINT: string = ''; const Body: string = ''): TJSONObject;
  end;

implementation

const
  BASE_URL = 'http://localhost:8080/api';

  { API }

class function API.CreateReq(const ENDPOINT: String): TRESTRequest;
var
  RestClient: TRESTClient;
  RestRequest: TRESTRequest;
  RestResponse: TRESTResponse;
begin
  RestClient := TRESTClient.Create(nil);
  RestRequest := TRESTRequest.Create(nil);
  RestResponse := TRESTResponse.Create(nil);

  RestClient.BaseURL := BASE_URL + ENDPOINT;

  RestRequest.Client := RestClient;
  RestRequest.Response := RestResponse;
  RestRequest.AcceptCharset := 'utf-8, *;q=0.8';

  RestRequest.Params.Clear;
  RestRequest.Params.AddItem('Accept', 'application/json; charset=utf-8',
    pkHTTPHEADER, [poDoNotEncode]);
  RestRequest.Params.AddItem('Content-Type', 'application/json; charset=utf-8',
    pkHTTPHEADER, [poDoNotEncode]);

  RestResponse.ContentType := 'application/json; charset=ISO-8859-1';

  // Retorna o RestRequest configurado
  Result := RestRequest;
end;

class function API.doReq(const Method: string = 'GET';
  const ENDPOINT: string = ''; const Body: string = ''): TJSONObject;
var
  RestRequest: TRESTRequest;
  loMethod: TRESTRequestMethod;
  loData: string;
  loArray: TJSONArray;

  JSONValue: TJSONValue;
  JSONObject: TJSONObject;

begin
  RestRequest := CreateReq(ENDPOINT);
  try
    try
      case AnsiIndexStr(Method, ['GET', 'POST', 'DELETE', 'PUT']) of
        0:
          loMethod := rmGET;
        1:
          loMethod := rmPOST;
        2:
          loMethod := rmDELETE;
        3:
          loMethod := rmPUT;
        -1:
          loMethod := rmGET;

      end;

      RestRequest.Method := loMethod;
      RestRequest.Params.Clear;
      RestRequest.Body.ClearBody;
      RestRequest.Body.Add(Body, ContentTypeFromString('application/json'));
      RestRequest.Execute;

      loData := RestRequest.Response.JSONValue.toString;

      // Tenta fazer o parse da resposta JSON
      JSONValue := TJSONObject.ParseJSONValue(loData);

      // Verifica se o JSON é um objeto ou outro tipo
      if JSONValue is TJSONObject then
        JSONObject := JSONValue as TJSONObject
      else
        Result := nil;

      Result := JSONObject;

    except
      on ex: exception do
      begin
        ShowMessage(ex.Message);
        Result := nil;
      end;
    end;
  finally
    // Libera memória dos componentes
    RestRequest.Client.Free;
    RestRequest.Response.Free;
    RestRequest.Free;
  end;

end;

end.
