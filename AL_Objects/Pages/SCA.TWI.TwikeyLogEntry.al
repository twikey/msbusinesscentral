page 71016576 "SCA.TWI.TwikeyLogEntry"
{
    Caption = 'Twikey Log Entry';
    DeleteAllowed = false;
    Editable = false;
    InsertAllowed = false;
    ModifyAllowed = false;
    PageType = Card;
    SourceTable = "SCA.TWI.TwikeyLogEntry";

    layout
    {
        area(content)
        {
            group(Algemeen)
            {
                field("Entry No."; Rec."Entry No.")
                {
                    ApplicationArea = All;
                }
                field("Date and Time"; Rec."Date and Time")
                {
                    ApplicationArea = All;
                }
                field("Time"; Rec.Time)
                {
                    ApplicationArea = All;
                }
                field("User ID"; Rec."User ID")
                {
                    ApplicationArea = All;
                }
                field(URL; Rec.URL)
                {
                    ApplicationArea = All;
                }
                field(Method; Rec.Method)
                {
                    ApplicationArea = All;
                }
                field("Status Code"; Rec."Status Code")
                {
                    ApplicationArea = All;
                }
                field("Status Description"; Rec."Status Description")
                {
                    ApplicationArea = All;
                }
            }
            group(Data)
            {
                ObsoleteReason = 'Replaced by userfrindley controls for dispaying JSON data.';
                ObsoleteState = Pending;
                ObsoleteTag = '16.7.0.0';
                Visible = true;

                field(RequestText; Rec.GetRequest())
                {
                    ApplicationArea = All;
                    Caption = 'Request';
                    MultiLine = true;
                }
                field(ResponseText; Rec.GetResponse())
                {
                    ApplicationArea = All;
                    Caption = 'Response';
                    MultiLine = true;
                }


            }
            group(JsonData)
            {
                Caption = 'Json Data Viewer';


                usercontrol(JsonViewer; "SCA.TWI.JsonLeftRightViewer")
                {
                    ApplicationArea = All;


                    trigger OnControlReady()
                    begin
                        Sleep(200);
                        JsonViewerReady := true;
                        UpdateJsonViewers();
                    end;
                }

            }


        }
        area(factboxes)
        {
            systempart(Links; Links)
            {
                ApplicationArea = All;
                Visible = false;
            }
            systempart(Notes; Notes)
            {
                ApplicationArea = All;
            }
        }
    }

    var
        JsonViewerReady: Boolean;
        RequestLabel: label 'Request';
        ResponseLabel: Label 'Response';

    trigger OnAfterGetCurrRecord();
    begin
        UpdateJsonViewers();
    end;

    /// <summary> 
    /// Update Json Viewers.
    /// </summary>
    local procedure UpdateJsonViewers()
    begin
        if JsonViewerReady then begin
            CurrPage.JsonViewer.SetLeftCaption(RequestLabel);
            CurrPage.JsonViewer.SetRightCaption(ResponseLabel);
            if Rec.Method = 'GET' then begin
                CurrPage.JsonViewer.SetLeftJsonData('');
            end else begin
                CurrPage.JsonViewer.SetLeftJsonData(Rec.GetRequest());
            end;
            CurrPage.JsonViewer.SetRightJsonData(Rec.GetResponse());
        end;
    end;
}

