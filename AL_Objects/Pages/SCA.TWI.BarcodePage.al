page 71016581 "SCA.TWI.BarcodePage"
{
    PageType = Card;
    SourceTable = "SCA.TWI.Barcode";
    Caption = 'QR Code Card';
    DataCaptionExpression = Value;

    layout
    {
        area(content)
        {
            group(General)
            {
                Caption = 'General';
                field(Value; Value)
                {
                    ApplicationArea = All;
                }
                field(Type; Type)
                {
                    ApplicationArea = All;

                    trigger OnValidate()
                    begin
                        CurrPage.Update;
                    end;
                }
                field(PictureType; PictureType)
                {
                    ApplicationArea = All;
                }
            }
            group(Options)
            {
                Caption = 'Options';
                group(Barcode)
                {
                    Enabled = false;
                    Visible = false;
                    //Visible = Type <> Type::QR;
                    field(Width; Width)
                    {
                        ApplicationArea = All;
                    }
                    field(Height; Height)
                    {
                        ApplicationArea = All;
                    }
                    field(IncludeText; IncludeText)
                    {
                        ApplicationArea = All;
                    }
                    field(Border; Border)
                    {
                        ApplicationArea = All;
                    }
                    field(ReverseColors; ReverseColors)
                    {
                        ApplicationArea = All;
                    }
                }
                group(QRCode)
                {
                    Enabled = false;
                    Visible = false;
                    //Visible = Type = Type::QR;
                    field(ECCLevel; ECCLevel)
                    {
                        ApplicationArea = All;
                    }
                    field(Size; Size)
                    {
                        ApplicationArea = All;
                    }
                }
            }
            part(BarcodePicture; "SCA.TWI.BarcodePicture")
            {
                ApplicationArea = All;
                SubPageLink = PrimaryKey = field(PrimaryKey);
            }


        }
        // area(FactBoxes)
        // {

        //     part(BarcodePicture; "SCA.TWI.BarcodePicture")
        //     {
        //         ApplicationArea = All;
        //         SubPageLink = PrimaryKey = field(PrimaryKey);
        //     }
        //     part(Test; "Sales Line FactBox")
        //     {
        //         ApplicationArea = All;

        //     }
        // }
    }

    actions
    {
        area(Processing)
        {
            action(GenerateBarcode)
            {
                ApplicationArea = All;
                Caption = 'Generate Image';
                Image = BarCode;
                Promoted = true;
                PromotedCategory = Process;
                PromotedIsBig = true;
                PromotedOnly = true;
                trigger OnAction();
                begin
                    GenerateBarcode;
                end;
            }
        }
    }

    var
        myInt: Integer;
}