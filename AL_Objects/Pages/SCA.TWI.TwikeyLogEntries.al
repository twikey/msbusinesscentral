page 71016575 "SCA.TWI.TwikeyLogEntries"
{
    Caption = 'Twikey Log Entries';
    CardPageID = "SCA.TWI.TwikeyLogEntry";
    Editable = false;
    InsertAllowed = false;
    PageType = List;
    PromotedActionCategories = 'New,Process,Report,Log Entries';
    SourceTable = "SCA.TWI.TwikeyLogEntry";
    SourceTableView = sorting("Entry No.") order(descending);

    layout
    {
        area(content)
        {
            repeater(Group)
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
                Visible = false;
            }
        }
    }

    actions
    {
        area(processing)
        {
            action(Delete7days)
            {
                ApplicationArea = All;
                Caption = 'Delete Entries Older Than 7 Days';
                Image = ClearLog;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Clear the list of log entries that are older than 7 days.';

                trigger OnAction();
                begin
                    Rec.DeleteEntries(7);
                end;
            }
            action(Delete0days)
            {
                ApplicationArea = All;
                Caption = 'Delete All Entries';
                Image = Delete;
                Promoted = true;
                PromotedCategory = Category4;
                PromotedIsBig = true;
                ToolTip = 'Clear the list of all log entries.';

                trigger OnAction();
                begin
                    Rec.DeleteEntries(0);
                end;
            }
        }
    }
}

