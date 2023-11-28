page 71016582 "SCA.TWI.BarcodePicture"
{
    PageType = CardPart;
    SourceTable = "SCA.TWI.Barcode";
    Caption = 'Image';

    layout
    {
        area(content)
        {
            field(Picture; Picture)
            {
                ApplicationArea = All;
                Editable = false;
                ShowCaption = false;
            }
        }
    }
}