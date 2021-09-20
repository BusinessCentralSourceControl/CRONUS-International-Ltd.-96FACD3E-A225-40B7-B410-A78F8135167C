dotnet // --> Reports ForNAV Autogenerated code - do not delete or modify
{	
	assembly("ForNav.Reports.6.0.0.2078")
	{
		type(ForNav.Report_6_0_0_2078; ForNavReport6188612_v6_0_0_2078){}   
	}
} // Reports ForNAV Autogenerated code - do not delete or modify -->

Report 6188612 "ForNAV Tax Service Invoice"
{
	Caption = 'Service Invoice';
	RDLCLayout = './Layouts/ForNAV Tax Service Invoice.rdlc'; DefaultLayout = RDLC;

	dataset
	{
		dataitem(Header;"Service Invoice Header")
		{
			DataItemTableView = sorting("No.");
			MaxIteration = 1;
			RequestFilterFields = "No.", "Posting Date";
			column(ReportForNavId_2; 2) {} // Autogenerated by ForNav - Do not delete
			column(HasDiscount; ForNAVCheckDocumentDiscount.HasDiscount(Header))
			{
				IncludeCaption = false;
			}
			dataitem(Line;"Service Invoice Line")
			{
				DataItemLink = "Document No." = FIELD("No.");
				DataItemLinkReference = Header;
				DataItemTableView = sorting("Document No.", "Line No.");
				column(ReportForNavId_3; 3) {} // Autogenerated by ForNav - Do not delete
				trigger OnPreDataItem();
				begin
				end;
				
			}
			dataitem(SalesTaxBuffer;"ForNAV Sales Tax Buffer")
			{
				DataItemTableView = sorting("Primary Key");
				UseTemporary = true;
				column(ReportForNavId_4; 4) {} // Autogenerated by ForNav - Do not delete
				trigger OnPreDataItem();
				begin
				end;
				
			}
			trigger OnPreDataItem();
			begin
			end;
			
			trigger OnAfterGetRecord();
			begin
			
				ChangeLanguage("Language Code");
				GetSalesTaxDetails;
			end;
			
		}
	}


	requestpage
	{

		SaveValues = true;

		layout
		{
			area(content)
			{
				group(Options)
				{
					Caption = 'Options';
					field(NoOfCopies; NoOfCopies)
					{
						ApplicationArea = All;
						Caption = 'No. of Copies';
						ToolTip = 'Specifies how many copies of the document to print.';
					}
					field(ForNavOpenDesigner; ReportForNavOpenDesigner)
					{
						ApplicationArea = All;
						Caption = 'Design';
						Visible = ReportForNavAllowDesign;
						trigger OnValidate()
						begin
							ReportForNav.LaunchDesigner(ReportForNavOpenDesigner);
							CurrReport.RequestOptionsPage.Close();
						end;
					}
				}
			}
		}

		actions
		{
		}
		trigger OnOpenPage()
		begin
			ReportForNavOpenDesigner := false;
		end;
	}

	trigger OnInitReport()
	begin
		;ReportsForNavInit;
		Codeunit.Run(Codeunit::"ForNAV First Time Setup");
		Commit;
		ReportForNavOpenDesigner := ReportForNavAllowDesign;
	end;

	trigger OnPostReport()
	begin

		;ReportForNav.Post;

	end;

	trigger OnPreReport()
	var
		ForNAVSetup: Record "ForNAV Setup";
	begin
		;

		ReportForNav.GetDataItem('Header').Copies( NoOfCopies);
		LoadWatermark;
		;ReportsForNavPre;

	end;
	var
		ForNAVCheckDocumentDiscount: Codeunit "ForNAV Check Document Discount";
		NoOfCopies: Integer;

	local procedure ChangeLanguage(LanguageCode: Code[10])
	var
		ForNAVSetup: Record "ForNAV Setup";
	begin
		ForNAVSetup.Get;
		if ForNAVSetup."Inherit Language Code" then
			CurrReport.Language(ReportForNav.GetLanguageID(LanguageCode));
	end;

	local procedure GetSalesTaxDetails()
	var
		ForNAVGetSalesTaxDetails: Codeunit "ForNAV Get Sales Tax Details";
	begin
		SalesTaxBuffer.DeleteAll;
		ForNAVGetSalesTaxDetails.GetSalesTax(Header, SalesTaxBuffer);
	end;

	local procedure LoadWatermark()
	var
		ForNAVSetup: Record "ForNAV Setup";
		OutStream: OutStream;
	begin
		ForNAVSetup.Get;
		if not PrintLogo(ForNAVSetup) then
			exit;
		ForNAVSetup.CalcFields(ForNAVSetup."Document Watermark");
		if not ForNAVSetup."Document Watermark".Hasvalue then
			exit;

		ForNavSetup."Document Watermark".CreateOutstream(OutStream); ReportForNav.Watermark.Image.Load(OutStream);

	end;

	procedure PrintLogo(ForNAVSetup: Record "ForNAV Setup"): Boolean
	begin
		if not ForNAVSetup."Use Preprinted Paper" then
			exit(true);
		if ReportForNav.PrinterSettings.PrintTo = 'PDF' then
			exit(true);
		if ReportForNav.PrinterSettings.PrintTo = 'Preview' then
			exit(true);
		exit(false);
	end;

	// --> Reports ForNAV Autogenerated code - do not delete or modify
	var 
		[WithEvents]
		ReportForNav : DotNet ForNavReport6188612_v6_0_0_2078;
		ReportForNavOpenDesigner : Boolean;
		[InDataSet]
		ReportForNavAllowDesign : Boolean;

	local procedure ReportsForNavInit();
	var
		addInFileName : Text;
		tempAddInFileName : Text;
		path: DotNet Path;
		ApplicationSystemConstants: Codeunit "Application System Constants";
	begin
		addInFileName := ApplicationPath() + 'Add-ins\ReportsForNAV_6_0_0_2078\ForNav.Reports.6.0.0.2078.dll';
		if not File.Exists(addInFileName) then begin
			tempAddInFileName := path.GetTempPath() + '\Microsoft Dynamics NAV\Add-Ins\' + ApplicationSystemConstants.PlatformFileVersion() + '\ForNav.Reports.6.0.0.2078.dll';
			if not File.Exists(tempAddInFileName) then
				Error('Please install the ForNAV DLL version 6.0.0.2078 in your service tier Add-ins folder under the file name "%1"\\If you already have the ForNAV DLL on the server, you should move it to this folder and rename it to match this file name.', addInFileName);
		end;
		ReportForNav:= ReportForNav.Report_6_0_0_2078(CurrReport.ObjectId(), CurrReport.Language(), SerialNumber(), UserId(), CompanyName());
		ReportForNav.Init();
	end;

	local procedure ReportsForNavPre();
	begin
		ReportForNav.OpenDesigner:=ReportForNavOpenDesigner;
		if not ReportForNav.Pre() then CurrReport.Quit();
	end;

	// Reports ForNAV Autogenerated code - do not delete or modify -->
}
