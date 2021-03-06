'******************************************************************************************************************************************
										''''Centralized Function Library for Loan IQ and CME''''
'******************************************************************************************************************************************


'**************************************Start of Public variable Declarations***************************************

Public  respth,resfolder,sreenfolder,resPath,descindex,ActLabelName,starttime, scrnShotFolder, CME_CSiFolder
Public field,testdescription,Commands,win_title_field,value,win_foldername
Public i,resPassed,resFailed,restextverify,rescomboverify,resclickbtverify,reslabelverify,proval
Public reswindowverify,respassedVerify,resFailedVerify,reswarnings,resquestions,rescompositeverify
Public Counter,ResultFile,ResultFile1,Suite
Public Row_Count,LoadGUIProperty_count
Public intlastDealNum,scrnShotURL
Public intdealnum, lastDealNum
Public FieldName,Diff,str_1, scrnShotTitle
'Dim StatusArray(500)
dim fail
dim ResNew,ResNew1
Public  CME_application,CME_Frame,CME_Frame2,CME_Frame3,CME_Verify_CSI_Documents, strURL

Dim CME_TestStepCount, CME_resPassed, CME_resFailed, CME_TS_Executed,CME_TC_ID
'CME_resPassed = 0
CME_resFailed=0
CME_TS_Executed=0
Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")
'Set CME_application = Browser("name:=Credit Management Enterprise").Page("title:=Credit Management Enterprise")
Set WebNavigator = Browser("name:=Loan IQ Web Navigator-Navigator").Page("title:=Loan IQ Web Navigator-Navigator")
'Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI").Page("title:=Ambit Optimist 8 - Business UI")
Set CME_RateQuote=Browser("title:=FCBT Rate Quote System.*").Page("title:=FCBT Rate Quote System")


Msgbox Environment.Value("EnvironmentName") 
'**************************************End of Public variable Declarations*****************************************


'**************************************Object Refrence variable Declarations*****************************************

'Dim deal_dynamic(100), deal_static(100), str, dealin, dealin1, Fldvalue, Compositeget, k, Coord1, Coord2, v, Button,Text_Get, Coord3, Coord4, Coord5, Coord6, Comboget, itm
'upd = 2 
'dim actual_cmp1
'
'**************************************End of Object Reference variable Declarations*****************************************


'**********************************************************************************************************
'Function 	: BaseScript 
'Description	: This function fetches the key words and data from the the action 
'		  sheet and calls the funtions to perform the required actions
'**********************************************************************************************************

Function BaseScript (Index)

Call updateCMEDatafile()

Call CME_CopyRepository() 'Copying OR to local  C: drive
Environment.value("usrFulNme") = CME_UsernameQuery
respth=split(Path,"\")
Suite =respth(5)
If Suite="CME_Automation" Then
		Datafilepath = respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\"&respth(7)&"\"&respth(8)&"\"&respth(9)
		
Else
	msgbox "Wrong Folder Structure"	
End If

'/*End  of Modified part for Centralized Library by MKT-S

Dim endtime
starttime=now
MyTime=time
Diff = False
descindex=1
'TTC =TestCaseCount(path)


	If Index = 1 then
		Dim App
'		Set App = CreateObject("QuickTest.Application")
'		App.Test.Settings.Run.ObjectSyncTimeOut = 80000
'		App.Test.SaveAs environment("TestDir")
'		Set App =  Nothing
		Set fso = CreateResultFile() 'Result file will be created at the start
	'Else 
		 'SystemUtil.CloseProcessByName("excel.exe") 
	End if

	Counter = Index	

	If Counter <> 1 Then

		respth1=split(Path,"\")
		Select Case  Suite

			Case "CME_Automation"
				resPath = respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\RESULTS"& "\"&respth(7)&"\"&respth(8)&"\"& Environment.Value("EnvironmentName") & "\" & respth(9)
				'setting Screenshots folder
				scrnShotFolder = respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\RESULTS"& "\"&respth(7)&"\"&respth(8)&"\"& Environment.Value("EnvironmentName")& "\Screenshots"
				Set filesys = CreateObject("Scripting.FileSystemObject")
				If Not filesys.FolderExists(scrnShotFolder) Then ' if folder doesn't exist then create a new folder
					scrnShotFolder = filesys.CreateFolder (scrnShotFolder)  
				End If
				'setting CSi results folder
				CME_CSiFolder=respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\RESULTS"& "\"&respth(7)&"\"&respth(8)&"\"& Environment.Value("EnvironmentName")& "\CME-CSi Results"
				If Not filesys.FolderExists(CME_CSiFolder) Then 
					CME_CSiFolder = filesys.CreateFolder(CME_CSiFolder) 
				End If	
				Set filesys = Nothing				
			Case "End_to_End_Automation_Scripts"     
				resPath =respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\RESULTS\"&respth(8)					
						
		End Select 

'Changing extension to .xlsx
	If Right(resPath,1)<>"x" Then
		resPath=resPath&"x"
	End If

		Set objExcel1 = CreateObject("Excel.Application")
		Set objWorkbook1 = objExcel1.Workbooks.Open(resPath)
		Set objWorksheet1 = objWorkbook1.Worksheets(1)   
		rowcount = objWorksheet1.UsedRange.Rows.Count
		dim tempvar
		Dim temp
		
		countd = objWorksheet1.cells(rowcount,5)
        Counter2 = Counter
		Tempvar = objWorksheet1.cells(5,5) + objWorksheet1.cells(5,6)
		for p = 6 to rowcount
			temp = split(objWorksheet1.cells(p,2),"|", -1, 1)
			arra =Split(temp (1),"Step.No",-1,1)

            		'aa = split( arra(1),")",-1,1)
			
			if int(Counter2) >= int(arra(1)) then
				Flag =False
			elseif int(Counter2)<= int(arra(1)) then
				Flag = True
				tempvar = p
				exit for
			end if
 
		next
		if Flag = True then
			For g = tempvar to rowcount
				objWorksheet1.cells(tempvar,2).EntireRow.delete 'Delete 
			Next
		End if
	
		objWorkbook1.save
 		objWorkbook1.Application.Quit
		Set objWorkbook1 = Nothing

	End If

	
	datatable.import(Datafilepath)
	Rowcount = datatable.GetRowCount ' Get max row count for iterating through the different steps of scenario 
	Row_Count = Rowcount

	For i = Index To Rowcount  
		Keyword = False
		datatable.SetCurrentRow i
		Commands = datatable.Value("Commands") 
		Commands = Trim(Commands)
		win_title_field = datatable.Value("Win_Title_Field") 
		value = datatable.Value("Value") 
		field = datatable.Value("Field")
		field = Trim(field) 
		testdescription = datatable.Value("TestDescription")
	    
	    Select Case Commands
	     	
	'************************* Start of CME keywords ******************************************

'****************************************************************
'Case name: CME_Login 
'Description: To Login to CME Application 
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A
'****************************************************************

	Case "CME_Login" 
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call CME_DynamicWait()
	   	Set login_username=CME_application.WebElement("attribute/fieldName:=WRK_USERNAME","visible:=true").WebEdit("visible:=true")
	    Set login_password=CME_application.WebElement("attribute/fieldName:=WRK_PASSWORD","visible:=true").WebEdit("visible:=true")
	    'Set login_button=CME_application.Object.getElementById("kc-login")
	    	BoolfieldExist=login_username.Exist(5) and login_password.Exist(5)' and login_button.Exist(5)
	    	
	   		pwd=CME_LoginData() 'Function gets called and returns password value with respect to username entered in field cell
		If BoolfieldExist=true and pwd<>"" Then
			login_username.Set Environment.Value("UserName")
			login_password.SetSecure pwd
			login_username.Click
			wait 0.5	
			Call CME_ClickButton("OK|Yes", "")
		ElseIf pwd="" Then
			scrnShotTitle="Password_field_is_empty"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
	    	On error goto 0
	    	Call CME_ExitTest() 
	    ElseIf BoolfieldExist=false Then
	    	scrnShotTitle="One_of_the_Login_Objects_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
		End If
		Set login_username=nothing
		Set login_password=nothing
		

'********************************************************************
'Case name: CME_GetDynamicAppNo

'*********************************************************************

Case "CME_GetDynamicAppNo"
        Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
		Set objAppNum = CME_application.WebElement("html tag:=DIV", "attribute/fieldName:=Resize Panel", "index:=0", "visible:=True")
'		Set objAppNum = CME_application.WebElement("html tag:=DIV","class:=label","innertext:=Application.*", "index:=0", "visible:=True")
		objAppNum.Highlight
'    	If objAppNum.Exist(10) Then
    	ArrAppNum = split(objAppNum.GetROProperty("innertext"), "Application #")
    	environment.Value("CurrAppNum") = ArrAppNum(1)
		'Call CME_GetApplicationNumber()
'If environment.Value("CurrAppNum") <> "" Then
'	
    	        dynVal=environment.Value("CurrAppNum")
'    	        msgbox dynVal
		  		call CME_FetchValueToGlobalVariable(value, dynVal)
'		  		Call CaptureScreen("Appnumber")
'		    	CME_ReportScreenshot(i)
'			Else 
'				scrnShotTitle="AppNo Not found"
'				Call CaptureScreen(scrnShotTitle)
'				CME_ReportFailed(i)
'				CME_resFailed=CME_resFailed+1			
'			End If
	
	

'****************************************************************
'Case name: CME_EnterText 
'Description: To Enter value in Text field 
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Pavan kumar(10/09/2018)
'****************************************************************
		
		Case "CME_EnterText"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    If value="" Then
	    	CME_EnterTextReportFailed(i)
	    	CME_resFailed=CME_resFailed+1
	    	'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	    	On error goto 0
	    	Call CME_ExitTest()
	    End If
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description

    	Set textField=CME_application.WebElement(objDesc).WebEdit("visible:=true") ' Modified by Muzaffar A. 
		If textField.Exist(10)=true Then
			If IsDate(value) = True Then
				value = mmddyyyy(value)
			End If
			textField.Set value
			'ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	   	    
		Set textField=nothing
		Set objDesc=Nothing 
	   
	   

		

'****************************************************************
'Case name: CME_ClkBtn 
'Description: To click Button 
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A , Subhash Patil and  Pavan kumar (10/09/2018)
'****************************************************************

	    Case "CME_ClkBtn"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next  		 	
    	Call CME_ClickButton(field, value)
    	
   	'********************************************************************
'Case name: CME_Verify_Enabled_FieldVal
'Description: Verifies the webedit field is enabled or not
'Created by : Automation Team
'Modified by and date:
'*********************************************************************			
	Case "CME_Verify_field_enabled" 
	  	Keyword = True
	  	CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
	  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		
	  	set enabledField=CME_application.WebElement(objDesc).WebEdit("visible:=true","attribute/readonly:=0")
		BoolfieldExist=enabledField.Exist(20) 'This will check whether the field is disabled or not
	    If BoolfieldExist=true Then
	    	strFieldval=enabledField.GetROProperty("readonly")
			If Trim(UCase(win_title_field)) = "" Then
				'If value="" Then 'Adding condition for verifying when the field value is empty
                	If strFieldval="0" Then
                		ReportPassed(i)
			    		'CME_resPassed='CME_resPassed+1
	                    
					Else
						scrnShotTitle="Filed enabled_not found"
						Call CaptureFailedObject(CME_application, enabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
			

	    End If
	 End  if
	    set enabledField=nothing
		Set objDesc=Nothing
		
			
'********************************************************************
'Case name: CME_CaptureApp_Fac_number
'Description: To verify auto generated field value
'Created by : Muzaffar A.
'Modified by and date:
'*********************************************************************	
		Case "CME_CaptureApp_Fac_number" 
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1		    
		    
		    Set objAppNum = CME_application.WebElement("html tag:=DIV", "attribute/fieldName:=Resize Panel", "index:=0", "visible:=True")
    		Set objAppNum = CME_application.WebElement("html tag:=DIV", "attribute/fieldName:=Resize Panel", "index:=0", "visible:=True")
    		If objAppNum.Exist(10) Then
    		ArrAppNum = split(objAppNum.GetROProperty("innertext"), "Application #")
    		intappnum = ArrAppNum(1)
    		msgbox intappnum
    		Set objFacNum = CME_application.WebElement("html tag:=INPUT", "name:=WebEdit", "outerhtml:=<input title="".*"" style=""margin: 0px; padding: 2px; border: 0px currentColor; border-image: none; left: 0px; top: 0px; width: 130px; height: 14px; text-align: left; color: rgb\(21, 21, 21\); font-family: Roboto, sans-serif; font-size: 8pt; font-style: normal; font-weight: normal; text-decoration: none; position: absolute; background-color: transparent;"" type=""text"" maxlength=""26"" readonly="""">", "index:=0", "visible:=True")
    		facnum =objFacNum.GetROProperty("value")
    		msgbox facnum
    		''Environment.Value
    		Environment.Value("CME_Appnum")=intappnum
    		Environment.Value("CME_Facnum")=facnum
    	   ''	File_Path = "\\nterprise.net\Bankdata\QA\CME_Automation\Datafiles\SmokeTest\REL201211007\ST_CFC_Trad_RQS.xls"
    	   	File_Path = Path
    	''	File_Path = "\\nterprise.net\Bankdata\QA\End_to_End_Automation_Scripts\Global_TestData\"& win_title_field &"\"& field &".xls"
    		Set oExcel = CreateObject("Excel.Application")
			oExcel.Visible = False
			oExcel.Workbooks.Open File_Path
			wait 5
			Set activeWSh = oExcel.ActiveWorkbook.Worksheets("MainDetails")
			activeWSh.Range("Application_Number") = intappnum
			activeWSh.Range("FacilityNumber") = facnum
		oExcel.ActiveWorkbook.Save
		oExcel.ActiveWorkbook.Close
		oExcel.Quit
		Set activeWSh = Nothing
		Set oExcel = Nothing
    	''	Msgbox Enviornment.value("CMEAppnum")
    	'ReportPassed(i)
	    'CME_resPassed='CME_resPassed+1
    Else 
    	scrnShotTitle="ApplicationNumberPanel_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		On error goto 0
		Call CME_ExitTest() 
    End If
'    Set objAppNum = Nothing
'		   'If intdealnum <> "" Then
'		   	Set ObjExcel = CreateObject("Excel.Application")
'			Set Objworkbook = ObjExcel.workbooks.open("\\nterprise.net\Bankdata\QA\CME_Automation\Scripts\Smoke\DealTeam_test\DataQueries\Extensibility_PostDealTeam4_RequestJsonBody_4\Extensibility_PostDealTeam4_RequestJsonBody_4.xls")
'			Set Objworksheet = Objworkbook.Worksheets("MainDetails")
'			
'			Objworksheet.Cells(2,3).Value = intappnum
'			Objworksheet.Cells(2,5).Value = facnum
'			'Objworksheet.Cells(5,5).Value = intappnum
'			Objworkbook.Save
'			Objworkbook.Close
'			Set Objworksheet = Nothing
'			Set Objworkbook = Nothing
'			Set ObjExcel = Nothing
			'ReportPassed(i)
            		'CME_resPassed='CME_resPassed+1
		'Else 
		'			msgbox("else part")
		'End If



Case "CME_DealTeam_CallAPI"
	
		 Keyword = True
	    
	    BoolfieldExist=False
		If respth(9)="ST_CFC_Agf_NewEnt_New.xls" and Environment.Value("EnvironmentName") = "FBLINTTST" Then
			
			
		RunAPITest "ST_CFC_Agf_NewEnt_New_API"

		ElseIf respth(9)="ST_CFC_Trad.xls" and Environment.Value("EnvironmentName") = "FBLINTTST" Then
			
		RunAPITest "ST_CFC_Trad_API"
		
		ElseIf respth(9)="ST_CFC_Agf_NewEnt_New.xls" and Environment.Value("EnvironmentName") = "FBLASSN" Then
			
			
		RunAPITest "APIDealTest_ASSN"
		
		ElseIf respth(9)="ST_CFC_Trad.xls" and Environment.Value("EnvironmentName") = "FBLASSN" Then
			
		RunAPITest "APIDealTest_ASSNTrad"
		
		ElseIf respth(9)="ST_CFC_Trad.xls" and Environment.Value("EnvironmentName") = "FBLTRAIN" Then
		msgbox "Suucessfully entered"
			

		RunAPITest "APIDealtest_Traintrad"
		msgbox "post api"
		
		ElseIf respth(9)="ST_CFC_Agf_NewEnt_New.xls" and Environment.Value("EnvironmentName") = "FBLTRAIN" Then
			
			
		RunAPITest "APIDealtest_TrainAgfast"

		Else
			MsgBox("Invalid scenario")
		End If
		'RunAPITest "Inso_Dealteam_raj"
		
'****************************************************************
'Case name: CME_VerifyDashboardScreen 
'Description: To Verify dashboard screen
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Pavan kumar
'****************************************************************	    
	    Case "CME_VerifyDashboardScreen"
		Call CME_DynamicWait()
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	  	set dashboard=CME_application.WebElement("class:=gridBox","attribute/fieldName:=Dashboard GridBox","visible:=true")
	  		BoolfieldExist=dashboard.Exist(60)
	  		If BoolfieldExist=true Then
	  		wait 1
				CME_application.WebElement("class:=mainMenuButton","visible:=True","index:=0","innertext:=Help").Click
				CME_application.WebElement("class:=menuButtonText","visible:=True","index:=0","innertext:=About Credit Management Enterprise").Click
				
			'	intRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=Release.*").GetROProperty("innertext")
			'	intSQLRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=SQL.*").GetROProperty("innertext")
				intPromotion=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=Promotion REL.*").GetROProperty("innertext")
				'wait 1
				Call CaptureScreen("PromotionRel")
				Set objExcel = CreateObject("Excel.Application")
				objExcel.visible = False
				Set objWorkbook = objExcel.Workbooks.Open(resPath)
				Set objWorksheet = objWorkbook.Worksheets(1)    	
				
				val = objWorksheet.UsedRange.Rows.Count
				val =val+1
				objWorksheet.Cells(2,1).Value="Environment URL:"
				objWorksheet.Cells(3,1).Value= "Promotion:"
				objWorksheet.Cells(2,2).Value = CME_application.GetROProperty("url")
				objWorksheet.Cells(3,2).Value= intPromotion
				'objWorksheet.Range("A2:A3").Font.Bold=true
				objWorksheet.Range("B2:B3").Interior.Color = vbyellow
				objWorksheet.Cells(5,7) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
				'Dim val
'				val = objWorksheet.UsedRange.Rows.Count
'				val =val+1
				
				resPassedVerify=resPassedVerify+1
				testdescription=replace(testdescription, "|", "_")
				objWorksheet.Cells(5,1) = field
				objWorksheet.Cells(5,2) = testdescription & "| Step.No" & i+1 & " |"
				objWorksheet.Cells(5,3) ="Passed"
				objWorksheet.Cells(5,4) = now()
				
				
				'msgbox resPassedVerify
				
'				objWorksheet.Cells(5,5) = resPassedVerify
'				objWorksheet.Cells(5,6) = resFailedVerify
				objWorkbook.save
				objWorkbook.Close 
				
				Set objWorksheet = Nothing
				Set objWorkbook = Nothing
				
				objExcel.Quit
				Set objExcel = Nothing
		  		'ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
				
				CME_application.WebElement("html tag:=A","visible:=True","index:=0","innertext:=OK").Click
			Else 
				scrnShotTitle="DashboardScreen_Not_Found"
	    		Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			Set dashboard=nothing
			
			
		   

'****************************************************************
'Case name: CME_SelectTermInstructions 
'Description: To Select term instrcutions based on inex numbers(Radio buttons)
'Created by : Automation team
'Modified by and date:
'****************************************************************
		
		Case "CME_SelectTermInstructions"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Indexnum = value
	    If CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).exist(2) = True Then
		   CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).Highlight
		   CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).Click	
		   ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="Terminstructions_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	   	    
		Set Terminstructions=nothing
		


'****************************************************************
'Case name: CME_Filladditionalblanks 
'Description: it fills additional blank fields in close term instructions page in pre-closing stage
'Created by : Automation team
'Modified by and date:
'****************************************************************	    
	    Case "CME_FillAdditionalBlanks"
		'Call CME_DynamicWait()
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    Stradditonalcheckbox = "0"
	    On error resume next
	  '	Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")
		CME_application.WebElement("WebElement:=checkBox","innertext:=Expand Additional Blanks").Highlight
		If CME_application.WebElement("WebElement:=checkBox","innertext:=Expand Additional Blanks").Exist(1) Then
			Stradditonalcheckbox = "1"
		Else
			scrnShotTitle="Expand additional checkbox verfication"
			 Call CaptureScreen(scrnShotTitle)
			 CME_ReportFailed(i)
			 CME_resFailed=CME_resFailed+1
		End If
		CME_application.WebElement("WebElement:=checkBox","innertext:=Expand Additional Blanks").Click
		Wait 2
		CME_application.WebElement("WebElement:=checkBox","innertext:=Expand Additional Blanks").Highlight
		Set OPgdn = Createobject("Wscript.Shell")
		OPgdn.SendKeys "{PGDN 2}"
		Set OPgdn = Nothing
		''Chld objects
		Set Odesc = Description.Create
		Odesc("name").value = "WebEdit"
		''Odesc("html tag").value = "TEXTAREA"
		Odesc("type").value = "textarea"
		intj = 0
		Set objchild = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding").Frame("html tag:=IFRAME","title:=Credit Management Enterprise").ChildObjects(Odesc)
		n= objchild.Count
		Startrow = n-5
		For inti = Startrow To n
		    Strtext = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding").Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebEdit("name:=WebEdit","index:="&inti).GetROProperty("innertext")
		    If Strtext = "" Then
		    	intj = intj+1
		    	Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding").Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebEdit("name:=WebEdit","index:="&inti).Highlight
		    	Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding").Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebEdit("name:=WebEdit","index:="&inti).Click
		        Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding").Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebEdit("name:=WebEdit","index:="&inti).Set "Term-Closing instructions"&intj
		        If intj = 5 and Stradditonalcheckbox = "1" Then
		        ReportPassed(i)
		        Exit for
		        End If
		    End If
		Next
		If intj = 0 Then
			scrnShotTitle="Fill additional blank fields_Term-closing instructions"
			 Call CaptureScreen(scrnShotTitle)
			 CME_ReportFailed(i)
			 CME_resFailed=CME_resFailed+1
		End If



	   

'****************************************************************
'Case name: CME_Selectterminstrcutions_textbased 
'Description: To Select term instrcutions radio button  based on instructions text and also it selects based on index numbers as well
'Created by : Automation team
'Modified by and date:
'****************************************************************
		
		Case "CME_SelectTermInstrdb_textval"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Strtext = field
	    CME_application.WebEdit("innertext:="&Strtext,"index:=0").Highlight
	    Strboolexist = CME_application.WebEdit("innertext:="&Strtext,"index:=0").exist(2)
	    If Strboolexist = True Then
	   	Indexnum = value
	    If CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).exist(1) = True Then
		   CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).Highlight
		   CME_application.WebElement("class:=radioButton","fieldname:=configField53209_N","index:="&Indexnum).Click	
		   ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="Terminstructionsradiobutton_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	  Else
	  		scrnShotTitle="Terminstructionstext_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
	End  If   	    



'****************************************************************
'Case name: CME_addtext_terminstructions
'Description: Thiskeyword will enter additional text based on instructions
'Created by : Automation team
'Modified by and date:
'****************************************************************
		
		Case "CME_addtext_terminstructions"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Strtext = field
	    Stradditionaltext = value
	    CME_application.WebEdit("innertext:="&Strtext,"index:=0").Highlight
	    Strboolexist = CME_application.WebEdit("innertext:="&Strtext,"index:=0").exist(2)
	    If Strboolexist = True Then
	   		CME_application.WebEdit("innertext:="&Strtext,"index:=0").Set Strtext&" "&Stradditionaltext
	   		 ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="Addtext_terminstructions"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	
	

''
'********************************************************************
'Case name: CME_ECM_ArchiveDoc
'Description: Archives Document in Rel. Docs screen based on the Document Description
'Created by : Muzaffar A
'Modified by and date: 
'field = Document Description
'*********************************************************************	

Case "CME_ECM_ArchiveDoc_HostkeywordVal"
	Keyword = True
    CME_TS_Executed=CME_TS_Executed+1
    On error resume Next
    
	set gridBox = CME_application.WebElement("class:=gridBox", "attribute/fieldname:=relDocsGridBox", "visible:=true")
	
	If gridBox.Exist(20) Then
		'Description for column header name
		Set colheader=description.Create
		colheader("micClass").Value="WebElement"
		colheader("class").Value="gridBoxColumnHeader"
		
		'Getting the count of columns in the gridbox
		Set obj1=gridBox.Childobjects(colheader)
		columnCount=obj1.count
		'Getting the column names along with their position number in the grid to dictionary object
		Set dict = CreateObject("Scripting.Dictionary")
		For icol = 0 To columnCount-1
			dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
		Next
		
		'We specify column name in field and fetch it's position number in the grid from the dictionary object
		colNum=Trim(dict.Item("DESCRIPTION"))		
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rowcount=objCell.Count 'Getting the rowcount of the grid
	
		For igrdRw = 0 To rowcount - 1
		
			cellValue = objCell(igrdRw).GetROProperty("innertext")
			If ucase(trim(cellValue))=ucase(trim(field)) Then
	            idntfrRowNum = igrdRw'CME_resPassed+1                 
	        	Exit For
	        End If
		Next
		
		colNum=Trim(dict.Item("ID"))
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		
		objCell(idntfrRowNum).Click
		wait 0.5
		
		Call CME_ClickButton("Archive", "")
		Call CME_DynamicWait()
		
		Set hstKywrdWnd = CME_application.WebElement("class:=container", "innertext:=Host Keywords.*", "visible:=true")
	''Validate host keyword screen	
		If hstKywrdWnd.Exist(10) Then
		Call ReportPassed(i) 
    Else 
		scrnShotTitle="Hostkeywordscreen_Failed"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
	End  If
		If hstKywrdWnd.Exist(10) Then
			If Trim(value) <> "" Then
				Set label = CME_application.WebElement("attribute/fieldName:=Document Creation Date","visible:=true","index:=0")
				Set objWebEdit=label.Object.PreviousSibling.lastchild
				strFieldval = objWebEdit.Title
				Call CME_FetchValueToGlobalVariable(value, strFieldval)
	  		End If
	  Arrhostkeywords = Split(value,";")
''msgbox Arrhostkeywords(0)
''msgbox  Arrhostkeywords(1)
	'''Validate Association and branch fields in host keywrds screen
    Set branch = CME_application.WebElement("attribute/title:="&Trim(Arrhostkeywords(0)),"visible:=true","index:=0")
        If branch.exist(4) Then
        testdescription = "Verify Association in hostkeyword screen"
    	Call ReportPassed(i) 
    Else 
		scrnShotTitle="Associationhostkeyword_Failed"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
    End If
	
	 Set Association = CME_application.WebElement("attribute/title:="&Arrhostkeywords(1),"visible:=true","index:=0")
        If Association.exist(4) Then
         testdescription = "Verify branch in hostkeyword screen"
    	Call ReportPassed(i) 
    Else 
		scrnShotTitle="branchfieldhostkeyword_Failed"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
    End If

	Call CME_ClickButton("OK", "")
			Call CME_DynamicWait()
			'We specify column name in field and fetch it's position number in the grid from the dictionary object
			colNum=Trim(dict.Item("STATUS"))		
			'We use column number as an index gridBoxColumn object below
			indx=colNum-1
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
			Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rowcount=objCell.Count 'Getting the rowcount of the grid
			cellValue = objCell(igrdRw).GetROProperty("innertext")
				If ucase(trim(cellValue))=ucase(trim("ARCHIVED")) Then
				  testdescription = "Verify document status archived"
		           Call ReportPassed(i) 
		        Else 
					scrnShotTitle="Archiving_Failed"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1		        
		        End If
			
		End If
		
		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		
		
	Else 
		scrnShotTitle="Grid_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
	End If

Set colheader = Nothing
Set obj1 = Nothing
Set dict = Nothing
Set gridBoxColumn = Nothing
Set objCell = Nothing
set gridBox = Nothing
Set objDesc = Nothing


'****************************************************************
'Case name: CME_ClkMenuItem
'Description: To click menu items
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Divya
'****************************************************************
		
		Case "CME_ClkMenuItem" 
			Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    Set menuItem=CME_application.WebElement("class:=mainMenuButton","attribute/fieldName:=" & Win_Title_Field,"index:=0","visible:=true")
	    	BoolfieldExist=menuItem.Exist(10)
	    	If BoolfieldExist=true Then
			 	menuItem.Click
			 	If field<>"" Then
			 		Set item=CME_application.WebElement("class:=menuButton","attribute/fieldName:=" & field,"index:=0")',"visible:=true")
					If item.Exist(10)=true Then
				    	item.Click
				    	If value<>"" Then
				    		Set item2=CME_application.WebElement("class:=menuButton","attribute/fieldName:=" & field,"index:=0")
				    		item2.Click
				    	End If
				    	'CME_resPassed='CME_resPassed+1
					    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				    Else 
				    	scrnShotTitle="MenuItem_Not_Found"
	                	Call CaptureFailedObject(CME_application, menuItem, scrnShotTitle)
				    	CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				 	End If
			 	End If
			 	
				
			Else 
				scrnShotTitle=Win_Title_Field&"_Menu_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				On error goto 0
				Call CME_ExitTest()
			End If
			Set item=nothing
			Set menuItem=nothing

'****************************************************************
'Case name: CME_SelectRadioBtn
'Description: To select Radio Button
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Shruthi
'****************************************************************
		
		Case "CME_SelectRadioBtn" 
			Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description
			
		    Set radioButton=CME_application.WebElement(objDesc)
	    	If radioButton.Exist(10)=True Then
	    		unchecked=radioButton.GetROProperty("innerhtml")
	    	    'This line checks if the radio button is not checked. If it is not then checks it. If it is already checked then it will skip it
	    		If Instr(unchecked,"_twr_=Radio_unchecked")>0 Then
	    			radioButton.Click
	    			'wait 1
	    			checked=radioButton.GetRoProperty("innerhtml")
	    			If Instr(checked, "_twr_=Radio_checked")>0 Then
		    			'CME_resPassed='CME_resPassed+1
					    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					Else 
						scrnShotTitle="FailedToHighlight"
						Call CaptureFailedObject(CME_application, radioButton, scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If    
	    		End If	
	   		Else 
				scrnShotTitle="RadioButton_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'				On error goto 0
'				Exittest
			End If
			
			Set unchecked=nothing
			Set radioButton=nothing
			Set objDesc=Nothing
'********************************************************************
'Case name: CME_ValidateDealNumber_EventLogScreen	
'Description: 
'Created by : Subhash Patil
'Modified by and date: 04/03/2019
'********************************************************************* 		
	Case  "CME_ValidateDealNumber_EventLogScreen"		
		   	Keyword = True
	   	 	CME_TS_Executed=CME_TS_Executed+1
	    	BoolfieldExist=False
	    	On error resume next
	    	
	    		If UCase(Trim(Win_Title_Field))="DEALALIAS" Then
	    		intdealval=CME_application.WebElement("html tag:=SPAN","innertext:=.* - Status: .*","index:=1").GetROProperty("innertext")
			    intstrlen=len(intdealval)
			    For j = 1 To intstrlen
			    	strdealval=Mid(intdealval,j,1)
			        If IsNumeric(strdealval) Then
			            intdealnum=intdealnum+strdealval
			        End If
		   		Next
		   		dynamicVal=intdealnum
		   		
			   	End If
	    	
		    
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
			
			CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).Highlight
    		 textField=CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).GetROProperty("innertext")
			
		If instr(1, dynamicVal, textField)>0 Then
			
			ReportPassed(i)
    		'CME_resPassed='CME_resPassed+1
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Exittest
	   End If
			    
	   Set textField=nothing
 '********************************************************************
'Case name: CME_EventLog_VerifyFieldVal
'Description: Verifies values in webedits in Event Log screens
'Created by : Subhash Patil
'Modified by and date: 02/06/2019
'********************************************************************* 	

Case "CME_EventLog_VerifyFieldVal"
	Keyword = True
	CME_TS_Executed=CME_TS_Executed+1
	BoolfieldExist=False
	On error resume next
	Arg=field
	propVal=CME_Value_from_Repository(Arg,"Value")
	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
	Set objDesc = Description.Create 'Creating description for the object
	For iProp = 0 To UBound(propValArr) 
	arr = split(propValArr(iProp),":=")  
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If				
	Next
	objDesc("visible").Value=true 'Adding Visible property to collection of description	
	
	Set textField = CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).Webedit("visible:=true")
	
	If textField.Exist(20) Then
		strFieldval = textField.GetROProperty("value")
		If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(value)))>0 Then
            ReportPassed(i)
			'CME_resPassed='CME_resPassed+1                 
        else
        	scrnShotTitle="Value_Not_Found"
        	Call CaptureFailedObject(CME_application, textField, scrnShotTitle)
            CME_VerifyFieldValReportFailed(i)
            CME_resFailed=CME_resFailed+1
            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
        End If
	Else 
		scrnShotTitle="TxtField_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	End If
	Set textField=nothing	
	Set objDesc=Nothing
'********************************************************************
'Case name: CME_EventLog_VerifyCurrDate
'Description: To verify current date with credit report date generated in Event Log screen in CME
'Created by : Subhash Patil
'Modified by and date:
'*********************************************************************  		
  	Case "CME_EventLog_VerifyCurrDate" 
  		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
	    	
		 Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		
			
		If Win_Title_Field <>"" Then		'''Modified Subhash Patil
			Set objField = CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).WebEdit("visible:=true")		'''Modified Subhash Patil		
		Else
			Set objField = CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).WebEdit("visible:=true")		'''Modified Subhash Patil			
		End If	
		
	    intFieldDate=objField.GetROProperty("value")
	    
  		dtmMonth= month(date)
		dtmDay=day(date)
		dtmYear=year(date)
		If len(dtmMonth)=1 Then
			dtmMonth=0&dtmMonth
		else
			dtmMonth=dtmMonth		
		End If
		If  len(dtmDay)=1 Then
			dtmDay=0&dtmDay
		else
			dtmDay=dtmDay
		End If
		dtmDate=dtmMonth&"/"&dtmDay&"/"&dtmYear
		dtmDiffdate=DateDiff("d",intFieldDate,dtmDate)
	If dtmDiffdate=1 OR trim(intFieldDate)=trim(dtmDate) OR dtmDiffdate=0 Then		''Modified by Subhash Patil
		ReportPassed(i)
  		'CME_resPassed='CME_resPassed+1
	Else
		scrnShotTitle="CurrentDate_Not_Found"
		Call CaptureFailedObject((CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise")), objField, scrnShotTitle)
		CME_VerifyFieldValReportFailed(i)
		CME_resFailed=CME_resFailed+1
		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	End If
	Set objField=Nothing
			
'****************************************************************
'Case name: CME_SelectFromList
'Description: To select values from list
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Subhash Patil 
'****************************************************************		
		
	Case "CME_SelectFromList"  		
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Arg=Win_Title_Field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating collection of description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		
		Set dropDownBtn=CME_application.WebElement(objDesc).WebEdit("visible:=true")'.WebElement("html tag:=DIV","outerhtml:=.*ddButton.png.*", "visible:=true")
		
		If dropDownBtn.Exist(20)=True Then
		    
		    'mySendKeys.SendKeys("{DOWN}")
			If Trim(win_title_field) = "Ent_Info_Legal_Address_County/Parish" OR Trim(win_title_field) = "RelatedEntities_County/parish" OR Trim(win_title_field) = "Collat_Info_Collateral_County" OR Trim(win_title_field) = "Collat_Info_Appraiser_if_applicable" Then
	    		 If Trim(win_title_field) = "Collat_Info_Appraiser_if_applicable" AND Environment.Value("EnvironmentName") = "FBLINTTST" Then
	    		 	dropDownBtn.Click
'					dropDownBtn.object.value = field
'				    dropDownBtn.Click
                    wait 0.5
		    		CME_application.WebElement("html tag:=DIV","class:=gridBoxCell", "index:=1", "visible:=true").FireEvent "onclick"
	    		 Else 
		    		 If dropDownBtn.GetROProperty("value") = "" Then
		    		 	dropDownBtn.Click
		    		 	wait 0.5
		    		 	CME_application.WebElement("html tag:=DIV","class:=gridBoxCell", "index:=1", "visible:=true").FireEvent "onclick"
		    		 	'CME_application.WebElement("html tag:=DIV","class:=gridBoxCell", "index:=1", "visible:=true").Click
	
	'					wait 0.5
	'		    		Call SendKeysCommoelementand("{DOWN}")
	'		    		wait 0.2
	'	    		 	call SendKeysCommand("{ENTER}")
		    		 End If
	    		 End If
	    	
	    	ElseIf Trim(win_title_field) = "Prod_Info_PaymentFrequency_DropDown" Then
	    		
	    		'dropDownBtn.Click
	    		Set dropDownItem = CME_application.WebElement("class:=gridBox", "innertext:=LN_INT_PAYMENT_FREQ_END_X.*", "index:=0").WebElement("class:=gridBoxCell", "innertext:="& field)
				    If dropDownItem.Exist(10)=true Then
						dropDownItem.click
					   	Reporter.ReportHtmlEvent micPass, Win_Title_Field & field,testdescription&"( Step.No" & i+1 & " )"	
				    Else
				    	Set dropDown=CME_application.WebElement(objDesc)
				    	scrnShotTitle="DropDownItem_Not_Found"
			        	Call CaptureFailedObject(CME_application, dropDown, scrnShotTitle)
				    	CME_ReportFailed(i)
				    	CME_resFailed=CME_resFailed+1
				    	'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		'				On error goto 0
		'				Exittest
						
				    End If
	    		
	    	Else 
				dropDownBtn.Click
				dropDownBtn.object.value = field
		    	dropDownBtn.Click	    	
		    End If 	
		    		
'		    Else
'		    	Set dropDown=CME_application.WebElement(objDesc)
'		    	scrnShotTitle="DropDownItem_Not_Found"
'	        	Call CaptureFailedObject(CME_application, dropDown, scrnShotTitle)
'		    	CME_ReportFailed(i)
'		    	CME_resFailed=CME_resFailed+1
'		    	'CME_FetchResultStatusAndEnterinFinalResults(resPath)
''				On error goto 0
''				Exittest
'				
'		    End If
'		
		Else 
			scrnShotTitle="DropDown_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
		End If
		
		set mySendKeys = Nothing
		Set dropDown=Nothing
		set dropDownBtn=nothing
		Set dropDownItem=nothing
		Set objDesc = Nothing

'****************************************************************
'Case name: CME_DropDownChkBx
'Description: To check checkbox  values in dropdown 
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************		
		
		Case "CME_DropDownChkBx" 
	        Keyword = True
	        CME_TS_Executed=CME_TS_Executed+1
	        BoolfieldExist=False
	        On error resume next
	        Arg=Win_Title_Field
	        propVal=CME_Value_from_Repository(Arg,"Value")
	        propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
			
	        set dropDownBtn=CME_application.WebElement(objDesc).WebEdit("visible:=true")'.WebElement("outerhtml:=.*ddButton.png.*")
	            
	            If dropDownBtn.Exist(10)=True Then
'		            dropDownBtn.object.value = 
'		            dropDownBtn.Click
'		            set mySendKeys = CreateObject("WScript.shell")
'		            mySendKeys.SendKeys("{DOWN}")
'		    		set mySendKeys = Nothing
	'	            wait 1
		'             Note: Some of the drop down checkboxes are identified by index and some of them are by innertext.
		'                   We adopt field for index and value for innertext:
		'                     -If drop down checkbox needs to be identified with innertext then leave field cell blank in data file 
		'                     -If drop down checkbox needs to be identified with index then leave value cell blank in data file
		            If field<>"" And value="" Then
		                dropDownBtn.Click
		               	Set dropDownItem=CME_application.WebElement("html tag:=DIV","class:=gridBoxContent", "index:=0","visible:=true").WebElement("html tag:=DIV","class:=gridBoxCell","index:=" & field,"outerhtml:=.*checked\.png.*", "visible:=true") '
                    ''    dropDownItem.Highlight 
		               dropDownItem.Click
		                dropDownBtn.Click
		                
		            ElseIf value<>"" And field="" Then
'		            
						dropDownBtn.object.value = value
		            	dropDownBtn.DoubleClick
		            	 
		            End If
	

		      
		        Else 
		            scrnShotTitle="DropDown_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'		            On error goto 0
'		            Exittest
		        End If
		   
		    Set dropDown=Nothing
	        set dropDownBtn=nothing
	        Set dropDownItem=nothing
			Set objDesc=Nothing
			
		
		
	
	
'****************************************************************
'Case name: CME_CreateModelInOptimist
'Description: Creates Model In Optimist
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A & Shruthi 
'****************************************************************
	Case "CME_CreateModel_Optimist"
	Keyword = True
	existingModel = False
    CME_TS_Executed=CME_TS_Executed+1
    'On error resume next
    Set srchType = CME_application.WebElement("class:=dropDownGridBox", "attribute/fieldname:=searchType", "visible:=true").WebEdit("visible:=true")
    srchType.Click
    srchType.Object.value = "Customer Name"
    srchType.Click
    wait 1
    Call CME_ClickButton("Search", 0)
    Call CME_DynamicWait()
	Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
	Set noRec = CME_application.WebElement("attribute/fieldName:=dataBox","visible:=true").WebElement("class:=gridBoxCell","innertext:=No Records Found","index:=0","visible:=true")
	boolFlag = noRec.Exist(5)
	If boolFlag = False Then 'When No Records Found in Optimist for entity
		Set LaunchBtn = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Launch","visible:=true","index:=0")
		If LaunchBtn.Exist(5) Then
			LaunchBtn.Click
			Call CME_DynamicWait
			If CME_application.WebElement("class:=label", "innertext:=Select Portfolio", "visible:=true").Exist(10) Then 'Portfolio selection dialog box
				If win_title_field <> "" Then
					Set PLB_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:="& win_title_field, "visible:=true")
				Else 
					Set PLB_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:=Plains Land Bank - Credit Analyst", "visible:=true")
				End If
				
				PLB_Portfolio.Click 'Selecting Portfolio as PLB
				CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK button after selection
				Call CME_DynamicWait
				Call dealModels_Error_PopUp()
				If CME_application.WebElement("class:=label", "innertext:=Warning", "visible:=true").Exist(2) Then 'Warning message pop up
					CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
					
				Else 
					'When warning message not available
				End If
				Call dealModels_Error_PopUp
				Optimist_App.Sync
				Set riskTab = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=ContentControl","parent text:=Risk","visible:=True","index:=0")
				If riskTab.Exist(20) Then 
					If win_title_field<>"" And ISnumeric(value)=True Then '''''' Modified by Shruthi for Pd overide scenario
						Call Re_Rate_Borrower()
					End If
					existingModel = True
					Browser("name:=Ambit Optimist 8 - Business UI").Close 'Closing Optimist Application after confirming in Launched in new tab
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else 
					Browser("CreationTime:=1").Highlight
					Browser("CreationTime:=1").Close 'Closing Optimist Application after confirming in Launched in new tab
					Reporter.ReportEvent micFail, "Step"&i,"_Optimist Page not found"
				End If
			Else 
				'When Portfolio selection dialog box not present
				Reporter.ReportEvent micFail, "Step"&i,"Portfolio Selection Not Found"				
			End If
		Else 
			'When Launch button not available
			Reporter.ReportEvent micFail, "Step"&i,"Launch button Not Found"				
		End If
	Else 
		Set CreateBtn = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Create","visible:=true","index:=0") 'Create Button
		If CreateBtn.Exist(5) Then
			CreateBtn.Click
			Call CME_DynamicWait()
			If CME_application.WebElement("class:=label", "innertext:=Select Portfolio", "visible:=true").Exist(10) Then 'Portfolio selection dialog box
				If win_title_field <> "" Then
					Set PLB_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:="& win_title_field, "visible:=true")
				Else 
					Set PLB_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:=Plains Land Bank - Credit Analyst", "visible:=true")
				End If
				'Set PLB_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:=" & field, "visible:=true")
				PLB_Portfolio.Click 'Selecting Portfolio as PLB
				CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK button after selection
				Call CME_DynamicWait
				Call dealModels_Error_PopUp()
				If CME_application.WebElement("class:=label", "innertext:=Warning", "visible:=true").Exist(3) Then 'Warning message pop up
					CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
					
				Else 
					'When warning message not available
				End If
				Call dealModels_Error_PopUp
				Optimist_App.Sync
				Optimist_App.highlight
				If Optimist_App.Exist(10) Then 
					'***************************** Risk Tab ******************************************
					Call Re_Rate_Borrower()
					
					Browser("name:=Ambit Optimist 8 - Business UI").Close 'Closing Optimist Application after confirming in Launched in new tab
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else 
					Browser("CreationTime:=1").Highlight
					Browser("CreationTime:=1").Close 'Closing Optimist Application after confirming in Launched in new tab
					Reporter.ReportEvent micFail, "Step"&i,"_Optimist Page not found"
				End If
			Else 
				'When Portfolio selection dialog box not present
				Reporter.ReportEvent micFail, "Step"&i,"Portfolio Selection Not Found"					
			End If
		Else 
			'When Create button not present
			Reporter.ReportEvent micFail, "Step"&i,"Create button Not Found"
		End If
		
	End If
	
	Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")
	If existingModel <> True Then
		CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Search","visible:=true","index:=0").Click
		wait 1
		Call CME_DynamicWait
	End If
	
	
	CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Refresh","visible:=true","index:=0").Click
	Call CME_DynamicWait
	If CME_application.WebElement("class:=label", "innertext:=Select Statements to Import", "visible:=true").Exist(10) Then
		wait 2
		set bx = CME_application.WebElement("html tag:=DIV","class:=gridBoxColumnHeader", "innertext:=Statement Date", "index:=0").Object.firstchild
		bx.click
		wait 2
		CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
	End If
	Call CME_DynamicWait
	
	
	Set LegalEntProfile_tab = Nothing
	Set PLB_Portfolio = Nothing
	Set CreateBtn = Nothing
	Set LaunchBtn = Nothing
	Set noRec = Nothing
	



	
'****************************************************************
'Case name: CME_CreateModelInOptimistCFC
'Description: Creates Model In Optimist
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A and Shruthi
'****************************************************************
	Case "CME_CreateModelInOptimistCFC"
	Keyword = True
    CME_TS_Executed=CME_TS_Executed+1
    'On error resume next
	Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
	Set noRec = CME_application.WebElement("attribute/fieldName:=dataBox","visible:=true").WebElement("class:=gridBoxCell","innertext:=No Records Found","index:=0","visible:=true")
	boolFlag = noRec.Exist(5)
	If boolFlag = False Then 'When No Records Found in Optimist for entity
		Set LaunchBtn = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Launch","visible:=true","index:=0")
		If LaunchBtn.Exist(5) Then
			LaunchBtn.Click
			Call CME_DynamicWait
			If CME_application.WebElement("class:=label", "innertext:=Select Portfolio", "visible:=true").Exist(10) Then 'Portfolio selection dialog box
				Set CFC_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:=Capital Farm Credit - Credit Analyst", "visible:=true")
				CFC_Portfolio.Click 'Selecting Portfolio as CFC
				CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK button after selection
				Call CME_DynamicWait
				Call dealModels_Error_PopUp()
				If CME_application.WebElement("class:=label", "innertext:=Warning", "visible:=true").Exist(5) Then 'Warning message pop up
					CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
					
				Else 
					'When warning message not available
				End If
				Call dealModels_Error_PopUp
				Optimist_App.Sync
				Optimist_App.highlight
				If Optimist_App.Exist(10) Then 
					
					Call Re_Rate_Borrower_CFC()

					Browser("name:=Ambit Optimist 8 - Business UI").Close 'Closing Optimist Application after confirming in Launched in new tab
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else 
					Browser("CreationTime:=1").Highlight
					Browser("CreationTime:=1").Close 'Closing Optimist Application after confirming in Launched in new tab
					Reporter.ReportEvent micFail, "Step"&i,"_Optimist Page not found"
				End If
			Else 
				'When Portfolio selection dialog box not present
				Reporter.ReportEvent micFail, "Step"&i,"Portfolio Selection Not Found"				
			End If
		Else 
			'When Launch button not available
			Reporter.ReportEvent micFail, "Step"&i,"Launch button Not Found"				
		End If
	Else 
		Set CreateBtn = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Create","visible:=true","index:=0") 'Create Button
		If CreateBtn.Exist(5) Then
			CreateBtn.Click
			Call CME_DynamicWait()
			If CME_application.WebElement("class:=label", "innertext:=Select Portfolio", "visible:=true").Exist(10) Then 'Portfolio selection dialog box
				Set CFC_Portfolio = CME_application.WebElement("class:=gridBoxCell", "innertext:=Capital Farm Credit - Credit Analyst", "visible:=true")
				CFC_Portfolio.Click 'Selecting Portfolio as PLB
				CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK button after selection
				Call CME_DynamicWait
				Call dealModels_Error_PopUp()
				If CME_application.WebElement("class:=label", "innertext:=Warning", "visible:=true").Exist(10) Then 'Warning message pop up
					CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
					
				Else 
					'When warning message not available
				End If
				Call dealModels_Error_PopUp
				Optimist_App.Sync
				Optimist_App.highlight
				If Optimist_App.Exist(10) Then 
					'***************************** Risk Tab ******************************************
					Call Re_Rate_Borrower_CFC()
					
					Browser("name:=Ambit Optimist 8 - Business UI").Close 'Closing Optimist Application after confirming in Launched in new tab
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else 
					Browser("CreationTime:=1").Highlight
					Browser("CreationTime:=1").Close 'Closing Optimist Application after confirming in Launched in new tab
					Reporter.ReportEvent micFail, "Step"&i,"_Optimist Page not found"
				End If
			Else 
				'When Portfolio selection dialog box not present
				Reporter.ReportEvent micFail, "Step"&i,"Portfolio Selection Not Found"					
			End If
		Else 
			'When Create button not present
			Reporter.ReportEvent micFail, "Step"&i,"Create button Not Found"
		End If
		
	End If
	
	Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")
	CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Search","visible:=true","index:=0").Click
	wait 1
	Call CME_DynamicWait
	
	CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Refresh","visible:=true","index:=0").Click
	Call CME_DynamicWait
	If CME_application.WebElement("class:=label", "innertext:=Select Statements to Import", "visible:=true").Exist(10) Then
		wait 2
		set bx = CME_application.WebElement("html tag:=DIV","class:=gridBoxColumnHeader", "innertext:=Statement Date", "index:=0").Object.firstchild
		bx.click
		wait 2
		CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=OK","visible:=true","index:=0").Click 'Clicking OK on Warning pop up
	End If
	Call CME_DynamicWait
	
	
	Set LegalEntProfile_tab = Nothing
	Set PLB_Portfolio = Nothing
	Set CreateBtn = Nothing
	Set LaunchBtn = Nothing
	Set noRec = Nothing
	
	
	
	

'****************************************************************
'Case name: CME_VerifyLogin
'Description: To verify login Screen
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************
		Case "CME_VerifyLogin"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    BoolfieldExist=CME_application.WebElement("innertext:=Bad Login").Exist(5)
	    If BoolfieldExist=True Then
	    	CME_VerifyLoginReportFailed(i)
		    Call CME_ExitTest() 
	   Else 
			ReportPassed(i)
			'CME_resPassed='CME_resPassed+1
		End If
		
		
'****************************************************************
'Case name: CME_Get_Screenshot
'Description: Takes screenshot of the screen
'Created by : Muzaffar A
'Modified by and date: 
'****************************************************************
	Case "CME_Get_Screenshot" 
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    'BoolfieldExist=False
	    On error resume next
	    field = Replace(field, " ", "_")
	    scrnShotTitle = ""
	    Call CaptureScreen(scrnShotTitle)
	    CME_ReportScreenshot(i)
		

'****************************************************************
'Case name: CME_SkipStep
'Description: Skips number of steps specified in Value column
'Created by : Muzaffar A
'Modified by and date: 
'****************************************************************
	Case "CME_SkipStep" 
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	  	i = i + value
'****************************************************************
'Case name: CME_DealTree_Expand
'Description: expand deal tree elements
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************
		
		Case "CME_DealTree_Expand" 
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    'BoolfieldExist=False
	    On error resume next
	    'DOM methods are used to identify the Expand Icon and also for verification
	    If Win_Title_Field<>"" Then
	    	If UCase(Trim(Win_Title_Field))="VERIFY ICON(+)" Then
	    		If value<>"" Then 
	    			set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=" & value).object.previousSibling.previousSibling
			    Else 
			    	set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=0").object.previousSibling.previousSibling
			    End If
				strSrc=expandIcon.src
				If instr(strSrc, "treeUnexpand")>0 Then
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else
					scrnShotTitle="ExpandIcon_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)		
				End If
				
			
			ElseIf UCase(Trim(Win_Title_Field))="VERIFY ICON(-)" Then
	    		If value<>"" Then 
	    			set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=" & value).object.previousSibling.previousSibling
			    Else 
			    	set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=0").object.previousSibling.previousSibling
			    End If
				strSrc=expandIcon.src
				If instr(strSrc, "treeExpand")>0 Then
					'CME_resPassed='CME_resPassed+1
					ReportPassed(i)
				Else
					scrnShotTitle="UnExpandIcon_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
				End If
			End If
			
		Else 
		
		    If value<>"" Then 
		    	set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=" & value).object.previousSibling.previousSibling
		    Else 
		    	set expandIcon=CME_application.WebElement("html tag:=SPAN","innertext:=" & field,"index:=0").object.previousSibling.previousSibling
		    End If
			strSrc=expandIcon.src 'Returns the src attribute value
			If instr(strSrc, "treeUnexpand")>0 or instr(strSrc, "treeExpand")>0  Then ' Removed .* from condition because it was not working for some elements by Pavan kumar
				expandIcon.click
				'CME_resPassed='CME_resPassed+1
			    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				
			Else
				scrnShotTitle="ExpandIcon_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				On error goto 0
				Call CME_ExitTest() 		
			End If
		End If
			set expandIcon=nothing

'****************************************************************
'Case name: CME_Check_Chkbx
'Description: To handle checkboxes
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************
		Case "CME_Check_Chkbx"
			Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    Set Chkbx=CME_application.WebElement("class:=checkBox","innertext:=" & field,"visible:=true")
		    	BoolfieldExist=Chkbx.Exist(20)
		    	If BoolfieldExist=True Then
		    			    		
		    		outrhtmlStr = Chkbx.GetROProperty("outerhtml")
		    		chkdFlag = Instr(Lcase(outrhtmlStr), "?_twr_=cb_unchecked")
		    		'Unchecking 
		    		If UCase(Trim(win_title_field)) = "UNCHECK" Then
		    			chkdFlag = Instr(Lcase(outrhtmlStr), "?_twr_=cb_checked")
		    			If chkdFlag > 0 Then
			    			Chkbx.Click
			    			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			    		End If
		    		
			    	'Checking		    	
		    		Else 	
		    			chkdFlag = Instr(Lcase(outrhtmlStr), "?_twr_=cb_unchecked") or  Instr(Lcase(outrhtmlStr), "/?_twr_=cb_uncheckednormal.png")
			    		'This line checks if the checkbox is not checked. If it is not then checks it. If it is already checked then it will skip it
			    		If chkdFlag > 0 Then
			    			Chkbx.Click
			    			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			    		End If
		    		End If
			
				Else 
					scrnShotTitle="Checkbox_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'					On error goto 0
'					Exittest
				End If
				
			Set Chkbx=nothing
'****************************************************************
'Case name: CME_VerifyImage
'Description: To verify images
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************
		Case "CME_VerifyImage" 
			Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    Arg=field
			propVal=CME_Value_from_Repository(Arg)
		    Set img=CME_application.Image("file name:=" & propVal)
		    BoolfieldExist=img.Exist(10)
	    	If BoolfieldExist=True Then
		    	ReportPassed(i)
		    	'CME_resPassed='CME_resPassed+1 
		    
		    Else 
				scrnShotTitle="Image_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			Set img=nothing
			
'****************************************************************
'Case name: CME_VerifyScreen
'Description: To verify screens
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A. 08/01/2020
'****************************************************************		
		Case "CME_VerifyScreen" 
	  		Keyword = True
		  	CME_TS_Executed=CME_TS_Executed+1
		  	BoolfieldExist=False
		  	On error resume next
		  	
		  	Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
		  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		 	Set Screen=CME_application.WebElement(objDesc)
			Call CME_DynamicWait()
		  	If field = "Documents_Screen" or field = "DueDiligenceTracking_Screen" Then
		  		Call CME_CSi_PopUP()
		  	End If
			
			
			BoolfieldExist=Screen.Exist(60)
			If BoolfieldExist=True Then
		    	
		    	If Ucase(Trim(Win_Title_Field)) = "SCREENSHOT" Then
		    		Call CaptureScreen("")
		    		CME_ReportScreenshot(i)
		    	Else 
		    		ReportPassed(i)
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		    	End If 
		    	
					
			Else 
				scrnShotTitle="Screen_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest() 
			End If
		set Screen = Nothing

'****************************************************************
'Case name: CME_CaptureScreenLoad
'Description: To verify screens
'Created by : EVRY Automation Team
'Modified by and date:Pavan on 09/04/2019
'****************************************************************		
		Case "CME_CaptureScreenLoadTime" 
	  		Keyword = True
		  	CME_TS_Executed=CME_TS_Executed+1
		  	BoolfieldExist=False
		  	On error resume next
		  	StartTime = Timer() 'Starting time
		  	Call CME_LoadingCircle()
		  	If UCASE(Trim(Win_Title_Field)) = "CSI_POPUP" Then
		  		Call CME_CSi_PopUP()
		  		Call CME_LoadingCircle()
		  	End If
		  	
		  	
		  	Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
		  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		 
			Set Screen=CME_application.WebElement(objDesc)
			BoolfieldExist=Screen.Exist(60)
			If BoolfieldExist=True Then
		    	EndTime = Timer() 'Ending time
				timeDiff = FormatNumber(EndTime - StartTime, 2) 'Recording elapsed time
		    	Call CME_ReportLoadTime(i, timeDiff)
		    		
			Else 
				scrnShotTitle="Screen_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest() 
			End If
		set Screen = Nothing
			


'****************************************************************
'Case name: CME_VerifyFieldVal
'Description: To verify text field values
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A 
'****************************************************************		
		Case "CME_VerifyFieldVal" 
            Keyword = True
            CME_TS_Executed=CME_TS_Executed+1
            BoolfieldExist=False
            On error resume next
            Arg=field
            propVal=CME_Value_from_Repository(Arg,"Value")
            propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=") 
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
            
            Set txtfield=CME_application.WebElement(objDesc).WebEdit("visible:=true")
            
            BoolfieldExist=txtfield.Exist(20)
            If BoolfieldExist=true Then
                If txtfield.GetROProperty("attribute/readonly")=1 Then
	            	scrnShotTitle="Field_Readonly"
					Call CaptureFailedObject(CME_application, txtfield, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
            	End If
                strFieldval=txtfield.GetROProperty("value")
              ''  msgbox strFieldval
                If value="" Then 'Adding condition for verifying when the field value is empty
                	If strFieldval="" Then
                		ReportPassed(i)
			    		'CME_resPassed='CME_resPassed+1
	                    
					Else
						scrnShotTitle="Value_Not_Matched"
						Call CaptureFailedObject(CME_application, txtfield, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
                	
               
                Else 
	                If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(ucase(trim(strFieldval)), ucase(trim(value))) >0  Then
	                    ReportPassed(i)
			    		'CME_resPassed='CME_resPassed+1
	                    
					Else
						scrnShotTitle="Value_Not_Found"
						Call CaptureFailedObject(CME_application, txtfield, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				 End If	
			Else 
				scrnShotTitle="TxtField_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		    End If
		    
		    set disabledField=nothing
			Set objDesc=Nothing


           

'****************************************************************
'Case name: CME_Verify_Element
'Description: To verify webelements
'Created by : EVRY Automation Team
'Modified by and date:Muzaffar A, Shruthi 12/12/2018 
'****************************************************************		    
	    Case "CME_Verify_Element"
	    	Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    If value="" Then
		    	ind=0
		    Else 
		    	ind=value
		    End If
		    If Win_Title_Field="" Then
		    	set element=CME_application.WebElement("html tag:=DIV","class:=label|gridBoxCell","innertext:=" & field&".*","visible:=true","index:="&ind)
		    Else
		    	Set element=CME_application.WebElement("html tag:=DIV|SPAN|P","class:=" & Win_Title_Field,"innertext:=" & field&".*","visible:=true","index:="&ind)
		    End If
		    
	  		BoolfieldExist=element.Exist(30)
	  		If BoolfieldExist=true Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			
			Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			set element=nothing



'********************************************************************
'Case name: CME_Verify_OptimistScreen
'Description: To verify Optimist window 
'Created by : Divya V C  
'Modified by and date: 08/13/2019
'*********************************************************************	    
	    Case "CME_Verify_OptimistScreen"
	    	Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    On error resume next
		   Set Optipage=Browser("creationtime:=1")
		strTitle=Optipage.GetROProperty("title")
		If Optipage.Exist(10)=True and UCase(right(strTitle,4))="Ambit Optimist 8 - Business" Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else 
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If		
			Set Optipage=Nothing
			set strTitle=nothing

'****************************************************************
'Case name: CME_Verify_Element
'Description: To verify checkbox
'Created by : Pavan kumar
'Modified by and date:Muzaffar A 
'****************************************************************			
			Case "CME_Verify_ChkboxElement" 
			Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next		    
		  	set element=CME_application.WebElement("html tag:=A","class:=checkBox","innertext:=" & field)
		  		BoolfieldExist=element.Exist(30)
		  		
		  		If BoolfieldExist=true Then
					If Ucase(Trim(win_title_field))<>"CHECKED" Then
		  				ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
		  			Else 
		  				Set checked=element.WebElement("outerhtml:=.*CB_checked.*")
		  				If checked.Exist(5)=True Then
		  					ReportPassed(i)
							'CME_resPassed='CME_resPassed+1
						Else 
							scrnShotTitle="Chkbox_NOT_Checked"
							Call CaptureFailedObject(CME_application, checked, scrnShotTitle)
							CME_VerifyFieldValReportFailed(i)
							CME_resFailed=CME_resFailed+1
							'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		  				End If
		  			End If
					
				Else 
					scrnShotTitle="ChkboxElement_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
			
			Set checked=Nothing
			set element=nothing
			
'****************************************************************
'Case name: CME_Verify_NoElement
'Description: To verify element when it is not present
'Created by : Prasann
'Modified by and date: Pavan kumar 09/10/2018
'****************************************************************			
		Case "CME_Verify_NoElement"          
        Keyword = True
        CME_TS_Executed=CME_TS_Executed+1
        BoolfieldExist=False
        On error resume next
        If Win_Title_Field="" Then
	         If value<>"" Then
			 	'Description for class label and gridboxCell elements. It will work for either objects
			  	set element=CME_application.WebElement("html tag:=DIV|SPAN","class:=label","innertext:=" & field,"index:="&value,"visible:=true")
			 Else
			    'Description for class label and gridboxCell elements. It will work for either objects
			  	set element=CME_application.WebElement("html tag:=DIV|SPAN","class:=label","innertext:=" & field,"visible:=true")
			 End if
		Else 
	    	set element=CME_application.WebElement("html tag:=DIV|SPAN|P","class:=" & Win_Title_Field,"innertext:=" & field,"visible:=true")
	    End If
        BoolfieldExist=element.Exist(5)
        If BoolfieldExist=False Then
            ReportPassed(i)
            'CME_resPassed='CME_resPassed+1
        Else 
        	scrnShotTitle="Element_Found"
			Call CaptureFailedObject(CME_application, element, scrnShotTitle)
            CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
        End If
        set element=nothing

'****************************************************************
'Case name: CME_GetDealNumAndSearch
'Description: To get deal number and searching deal number
'Created by : Pavan Kumar
'Modified by and date:Muzaffar A ,Pavan kumar 09/10/2018
'****************************************************************		
		Case "CME_GetDealNumAndSearch" 
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
			intdealnum = CME_GetDealNum
		    wait 2
			Set srchBtn = CME_application.Image("attribute/fieldName=Deal Search Icon","index:=0","visible:=true")
			If srchBtn.Exist(10) Then
				srchBtn.Click
				Set dealSrch = CME_application.WebElement("attribute/fieldName:=Deal Search","index:=0","visible:=true").WebEdit("index:=0","visible:=true")
				If dealSrch.Exist(10) Then
					dealSrch.Set intdealnum
					Set objWsh=Createobject("Wscript.shell")
					objWsh.SendKeys "{ENTER}"
				   	ReportPassed(i)
            		'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="DealSearchField_NotFound"
					Call CaptureScreen(scrnShotTitle)
		            CME_ReportFailed(i)
		            CME_resFailed=CME_resFailed+1
				End If
			
			Else 
				scrnShotTitle="SearchIcon_NotFound"
				Call CaptureScreen(scrnShotTitle)
	            CME_ReportFailed(i)
	            CME_resFailed=CME_resFailed+1
			End If		
			
			Set objWsh=Nothing
			set dealSrch=Nothing
			Set srchBtn = Nothing
			


'****************************************************************
'Case name: CME_Verify_Defaulted_RadioBtn
'Description: To verify default selected radiobutton 
'Created by : Evry Automation Team
'Modified by and date:Muzaffar A and Pavan Kumar
'****************************************************************	   
	  Case "CME_Verify_Defaulted_RadioBtn" 
			Keyword = True
			CME_TS_Executed=CME_TS_Executed+1
			BoolfieldExist=False
			On error resume next
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		
			Set radioButton=CME_application.WebElement(objDesc)
			BoolfieldExist=radioButton.Exist(10)
			If BoolfieldExist=True Then
				checked=radioButton.GetRoProperty("innerhtml")
				If Ucase(Trim(win_title_field))<>"UNCHECKED" Then
					If UCase(Trim(value))="DISABLED" Then
						
						If Instr(checked, "_twr_=Radio_checkedDisabled.png")>0 Then 'This line verifies if the radio button is checked in readonly mode. 
							ReportPassed(i)
		            		'CME_resPassed='CME_resPassed+1
						Else 
							scrnShotTitle="RadioButton_Not_Highlighted_OR_Not_Disabled"
							Call CaptureFailedObject(CME_application, radioButton, scrnShotTitle)
							CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1	
			    		End If
					Else 
						If Instr(checked, "_twr_=Radio_checked")>0 Then 'This line verifies if the radio button is checked
							ReportPassed(i)
		            		'CME_resPassed='CME_resPassed+1
						Else 
							scrnShotTitle="RadioButton_Not_Highlighted"
							Call CaptureFailedObject(CME_application, radioButton, scrnShotTitle)
							CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1	
			    		End If
					End If
					
		    	Else 
		    		If UCase(Trim(value))="DISABLED" Then 
						If Instr(checked, "_twr_=Radio_uncheckedDisabled.png")>0 Then 'This line verifies if the radio button is checked in readonly mode.
							ReportPassed(i)
		            		'CME_resPassed='CME_resPassed+1
						Else 
							scrnShotTitle="RadioButton_Highlighted_OR_Not_Disabled"
							Call CaptureFailedObject(CME_application, radioButton, scrnShotTitle)
							CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1	
			    		End If
			    	Else 
			    		If Instr(checked, "_twr_=Radio_unchecked")>0 Then 'This line verifies if the radio button is checked
							ReportPassed(i)
		            		'CME_resPassed='CME_resPassed+1
						Else 
							scrnShotTitle="RadioButton_Highlighted"
							Call CaptureFailedObject(CME_application, radioButton, scrnShotTitle)
							CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1	
			    		End If
					End If			    		
				End If
				
	   		Else 
				scrnShotTitle="RadioButton_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			
			Set unchecked=nothing
			Set radioButton=nothing
			Set objDesc=Nothing

'****************************************************************
'Case name: CME_Verify_DealTreeElement
'Description: To verify webelements in dealtree
'Created by : Evry Automation Team
'Modified by and date:Muzaffar A ,Pavan Kumar and Subhash Patil
'****************************************************************
		Case "CME_Verify_DealTreeElement" 
			Keyword = True
			CME_TS_Executed=CME_TS_Executed+1 
			BoolfieldExist=False
			On error resume next
			'Some deal tree elements have duplicates. For those cases we can give index in value column. 
			If value<>"" Then 
				'''''Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=" & field,"index:=" & value,"visible:=true")
				Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=.*" & field & ".*","index:=" & value,"visible:=true")	
			Else 
				'''''Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=" & field,"visible:=true")
				Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=.*" & field & ".*","index:=0","visible:=true")	
			End If
			BoolfieldExist=dealTreeEl.Exist(15)
			If BoolfieldExist=True Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1			
			Else
				scrnShotTitle="DealTreeElement_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			Set dealTreeEl=nothing

'********************************************************************
'Case name: CME_Verify_No_DealTreeElement
'Description: To verify webelements when it is not present in dealtree
'Created by : Evry Automation Team
'Modified by and date:Muzaffar A 
'*********************************************************************
		Case "CME_Verify_No_DealTreeElement"
				Keyword = True
				CME_TS_Executed=CME_TS_Executed+1
				BoolfieldExist=False
				On error resume next
				'Some deal tree elements have duplicates. For those cases we can give index in value column. 
				If value<>"" Then 
					Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=" & field,"index:=" & value,"visible:=true")
				Else 
					Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:=" & field,"visible:=true")
				End If
				BoolfieldExist=dealTreeEl.Exist(5)
				If BoolfieldExist<>True Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="DealTreeElement_Found"
					Call CaptureFailedObject(CME_application, dealTreeEl, scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
				Set dealTreeEl=nothing
				
'********************************************************************
'Case name: CME_Clck_Element
'Description: To click Webelements
'Created by : Evry Automation Team
'Modified by and date: Muzaffar A 
'*********************************************************************

	Case "CME_Clck_Element"
			Keyword = True
		    Tcs_Executed = Tcs_Executed+1
		    BoolfieldExist=False
		    On error resume next
			If Win_Title_Field="" Then
				If value<>"" Then
				 	'Description for class label and gridboxCell elements. It will work for either objects
				  	set element=CME_application.WebElement("html tag:=DIV","class:=label|gridboxCell","innertext:=" & field,"index:="&value,"visible:=true")
				Else
				    'Description for class label and gridboxCell elements. It will work for either objects
				  	set element=CME_application.WebElement("html tag:=DIV","class:=label|gridboxCell","innertext:=" & field,"index:=0","visible:=true")
				End if
			ElseIf Win_Title_Field<>"" and value<>"" Then 
				set element=CME_application.WebElement("html tag:=DIV|SPAN","class:=" & Win_Title_Field,"innertext:=" & field,"index:="&value,"visible:=true")
			Else 
		    	set element=CME_application.WebElement("html tag:=DIV|SPAN","class:=" & Win_Title_Field,"innertext:=" & field,"index:=0","visible:=true")				
		    End If
		  	BoolfieldExist=element.Exist(30)
		    If BoolfieldExist=true Then
		    	element.Click
		    	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
'		    	'wait 2
'				ReportPassed(i)
'				resPassed=resPassed+1
			Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				resFailed=resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			set element=nothing
		

	'********************************************************************
		'Case name: CME_RouteUser
		'Description: To Select user dynamically 
		'Created by : Pavan 		'date:11/11/2019
	'*********************************************************************	
			
		Case "CME_RouteUser"
			Keyword = True
		 	BoolfieldExist=False
		    On error resume next
			systemUser=Environment.Value("UserName")   'To get user name and store it to a variable
			If systemUser="pkumar0917" Then
				routeUser=trim("Pavan Kumar")
			ElseIf  systemUser= "pdeshpande0617" Then
			    routeUser = trim("Prasann Deshpande")
			ElseIf systemUser = "saila0917" Then
			    routeUser = trim("Shruti Aila")
			ElseIf systemUser = "dvitalapuracheluvego" Then
			    routeUser = trim("Divya Vitalapuracheluvegowda")
			ElseIf systemUser = "mabduholikov0418" Then
			    routeUser = trim("Muzaffar Abduholikov")
			ElseIf systemUser = "vvenkatesh0719" Then
			    routeUser = trim("Vaishnavi Venkatesh")
			End If
			
		set routefield=CME_application.WebElement("html tag:=div","class:=dropDownGridBox","attribute/fieldName:=NEXTUSER","visible:=true","index:=0")
		BoolfieldExist=routefield.Exist(30)
			If BoolfieldExist=true Then
			set routefieldbtn= routefield.Webelement("html tag:=DIV","outerhtml:=.*ddButton.png.*","visible:=true")
				routefieldbtn.Click
				set OSendKeys = CreateObject("WScript.shell")
				OSendKeys.SendKeys("{DOWN}")
				CME_application.WebElement("html tag:=div","class:=gridBoxCell","innertext:="&routeUser,"visible:=true","index:=0").Click 'selecting System user from Route dropdown 
				ReportPassed(i)
			 Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)			
			End If
		Set routefield=nothing
		Set routefieldbtn=nothing
		Set OSendKeys=nothing
			
'********************************************************************
'Case name: CME_SendKeysSecondCheckbox
'Description: To select second checkbox values in dropdown
'Created by : Subhash Patil
'Modified by and date:
'*********************************************************************			
			Case "CME_SendKeysSecondCheckbox"		
			Keyword = True
			CME_TS_Executed=CME_TS_Executed+1
			BoolfieldExist=False
			On error resume next
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description				
		               
		       
		       Set objWsh=Createobject("Wscript.shell") 
		       Set BoolfieldExist=CME_application.WebElement(objDesc)
		           BoolfieldExist.Click
			   	   wait 1
			   	   objWsh.SendKeys "{DOWN}"
			   	   wait 1
			   	   objWsh.SendKeys " "
			   	   wait 1.5
			   	   BoolfieldExist.Click
			   	   resPassed=resPassed+1
			       Set objWsh=Nothing



	


'********************************************************************
'Case name: CME_Verify_DynamicVal
'Description: To verify auto generated field value
'Created by : Muzaffar A.
'Modified by and date:
'*********************************************************************	
		
	Case "CME_Verify_DynamicVal"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	  	Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
	  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		set dynField = CME_application.WebElement(objDesc).WebEdit("visible:=true")
	  	If dynField.Exist(30) Then
	  		strFieldval=dynField.GetROProperty("value")
	  		If ucase(trim(value))="NUMERIC" Then 'When verifying populated value is numeric
				If IsNumeric(strFieldval)=True Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="Value_Not_Numeric"
					Call CaptureFailedObject(CME_application, dynField, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			ElseIf ucase(trim(value))="NOTEMPTY" Then 'When verifying field is not empty
				If trim(strFieldval)<>"" Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="Field_Empty"
					Call CaptureFailedObject(CME_application, dynField, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			Else 
		  		If ucase(trim(Environment.Value(value)))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(Environment.Value(value))))>0 Then		
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
					
				Else
					scrnShotTitle="DynamicValue_Not_Found"
					Call CaptureFailedObject(CME_application, dynField, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			End If
		Else 
			scrnShotTitle="TxtField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	  	End If
	  	
	  	set dynField = Nothing
	  	Set objDesc = Nothing
	  	
'********************************************************************
'Case name: CME_Verify_Btn
'Description: To verify buttons and screen Tabs exist or not in Core CME screens
'Created by : Evry Automation Team
'Modified by and date: Muzaffar A. 02/07/2019
'*********************************************************************		
		Case "CME_Verify_Btn"     
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    If Win_Title_Field="" Then
		    	If value<>"" Then 'value is used for index when verifying buttons with the same fieldname values in the screen. 
		    				  'By giving index we identify a button uniquely. Example: Product Info screen NAICS Search Buttons
		    	 	Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & field,"visible:=true","index:=" & value) 
			    Else 
			    	Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & field,"visible:=true") 
			    End If
			    
			    BoolfieldExist=button.exist(5)
			    If BoolfieldExist=True Then
			    	 If button.Object.tabIndex=0 AND button.Object.style.backgroundColor<>"rgb(237, 237, 237)"  Then 'Verifies if the button is NOT disabled and greyed out
				    	ReportPassed(i)
				    	'CME_resPassed='CME_resPassed+1
				    Else 
				    	scrnShotTitle="Button_Disabled"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				    End If 
				Else
					scrnShotTitle="Button_Not_Found"
					Call CaptureScreen(scrnShotTitle)			
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
		    ElseIf UCase(Trim(Win_Title_Field))="NOT PRESENT" Then 
		    	Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & field,"visible:=true")
		    	BoolfieldExist=button.exist(5)
			    If BoolfieldExist=False Then
			    	ReportPassed(i)
				    'CME_resPassed='CME_resPassed+1
				Else
					scrnShotTitle="Button_Found"
					Call CaptureFailedObject(CME_application, button, scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
		    End If
		    
			Set button=nothing
'********************************************************************
'Case name: CME_Verify_Disabled_Btn
'Description: To verify disabled buttons
'Created by : Automation Team
'Modified by and date:
'*********************************************************************		
		
	Case "CME_Verify_Disabled_Btn"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    If value<>"" Then 'value is used for index when verifying buttons with the same fieldname values in the screen. 
	    				  'By giving index we identify a button uniquely. Example: Product Info screen NAICS Search Buttons
	    	 Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & field,"visible:=true","index:=" & value) 
	    Else 
	    	Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & field,"visible:=true") 
	    End If
	    
	    BoolfieldExist=button.exist(10)
	  
	    If BoolfieldExist=True Then
		    If button.Object.tabIndex=-1 AND button.Object.style.backgroundColor="rgb(237, 237, 237)"  Then 'Verifies if the button is disabled and readonly
		    	ReportPassed(i)
		    	'CME_resPassed='CME_resPassed+1
		    Else 
		    	scrnShotTitle="Button_NOT_Disabled"
				Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
				CME_VerifyFieldValReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		    End If 
		Else 
			scrnShotTitle="DisabledButton_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set button=nothing
		
'********************************************************************
'Case name: CME_Verify_Disabled_FieldVal
'Description: Verifies the webedit field is disabled and verifies it's value if there is one
'Created by : Automation Team
'Modified by and date:
'*********************************************************************			
	Case "CME_Verify_Disabled_FieldVal" 
	  	Keyword = True
	  	CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
	  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		
	  	set disabledField=CME_application.WebElement(objDesc).WebEdit("visible:=true","attribute/readonly:=1")
		BoolfieldExist=disabledField.Exist(20) 'This will check whether the field is disabled or not
	    If BoolfieldExist=true Then
	    	strFieldval=disabledField.GetROProperty("value")
			If Trim(UCase(win_title_field)) = "" Then
				If value="" Then 'Adding condition for verifying when the field value is empty
                	If strFieldval="" Then
                		ReportPassed(i)
			    		'CME_resPassed='CME_resPassed+1
	                    
					Else
						scrnShotTitle="Value_Not_Matched"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
			
				Else 
					If IsDate(value) = True Then
						value = mmddyyyy(value)
					End If
					
			    	If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(value)))>0 Then		
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
						
					Else
						scrnShotTitle="Value_Not_Found"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				End If
				
			ElseIf Trim(UCase(win_title_field)) = "DOUBLE" Then
				If CDbl(value) = CDbl(strFieldval) Then
					ReportPassed(i)
				Else 
					scrnShotTitle="Data_Not_Matched"
					Call CaptureFailedObject(CRM_Page, objLabel, scrnShotTitle)
		    		CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			
			ElseIf Trim(UCase(win_title_field)) = "DYNAMIC" Then 'Condition for when field value is dynamic. In this case we give environment variable in value column.
				
				If ucase(trim(value))="NUMERIC" Then 'When verifying populated value is numeric
					If IsNumeric(strFieldval)=True Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Value_Not_Numeric"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If
				ElseIf ucase(trim(value))="NOTEMPTY" Then 'When verifying field is not empty
					If trim(strFieldval)<>"" Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Field_Empty"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If
				Else 
					
					valFromGlobalVar = CME_FetchValueFromGlobalVariable(value)
					If ucase(trim(valFromGlobalVar))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(valFromGlobalVar)))>0 Then		
							ReportPassed(i)
							'CME_resPassed='CME_resPassed+1
							
					Else
						scrnShotTitle="DynamicValue_Not_Found"
						Call CaptureFailedObject(CME_application, disabledField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				End If
			End If
			
		Else 
			scrnShotTitle="TxtField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	    End If
	   
	    set disabledField=nothing
		Set objDesc=Nothing
		
		
'********************************************************************
'Case name: CME_Clk_DealtreeElement
'Description: To click element in deal tree
'Created by : Pavan kumar
'Modified by and date:
'*********************************************************************		
		Case "CME_Clk_DealtreeElement" 
  		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    'Some deal tree elements have duplicates. For those cases we can give index in value column. 
			If value<>"" Then 
				Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:="&field&"|" & field & ".*","index:=" & value,"visible:=true")
			Else 
				Set dealTreeEl=CME_application.WebElement("html tag:=SPAN", "innertext:="&field&"|" & field & ".*","visible:=true")
			End If
	  	BoolfieldExist=dealTreeEl.Exist(10)
	    If BoolfieldExist=True Then
	    	dealTreeEl.Click
			ReportPassed(i)
			'CME_resPassed='CME_resPassed+1
		Else 
			scrnShotTitle="DealTreeElement_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 
		End If
		set dealTreeEl=nothing

'********************************************************************
'Case name: CME_ExitTest
'Description: To click branch in deal tree
'Created by : Muzaffar Abduholikov
'Modified by and date:
'*********************************************************************
	Case "CME_ExitTest" 
  		Keyword = True
	  	CME_TS_Executed=CME_TS_Executed+1
	  	Call CME_ExitTest()


'********************************************************************
'Case name: CME_Clk_DealtreeBranch
'Description: To click branch in deal tree
'Created by : Muzaffar Abduholikov
'Modified by and date:
'*********************************************************************
	Case "CME_Clk_DealtreeBranch" 
  		Keyword = True
	  	CME_TS_Executed=CME_TS_Executed+1
	  	Call CME_DynamicWait()
	  	BoolfieldExist=False
	  	On error resume next
	  	Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
	  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
	 
		Set dealTreeBranch=CME_application.WebElement(objDesc)	
	  	BoolfieldExist=dealTreeBranch.Exist(10)
	    
	    If BoolfieldExist=True Then
	    	dealTreeBranch.Highlight
	    	dealTreeBranch.Click
			ReportPassed(i)
			'CME_resPassed='CME_resPassed+1
		Else 
			scrnShotTitle="DealTreeElement_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 
		End If
		set dealTreeBranch=nothing
	

'********************************************************************
'Case name: CME_Expand_DealtreeBranch
'Description: To click branch in deal tree
'Created by : Muzaffar Abduholikov
'Modified by and date:
'*********************************************************************
	Case "CME_Expand_DealtreeBranch" 
	  		Keyword = True
		  	CME_TS_Executed=CME_TS_Executed+1
		  	BoolfieldExist=False
		  	On error resume next
		  	Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
		  	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		 	
			Set dealTreeBranch=CME_application.WebElement(objDesc)
			BoolfieldExist=dealTreeBranch.Exist(10)
			If BoolfieldExist=True Then
		    	set expandIcon = dealTreeBranch.object.previousSibling.previousSibling
				strSrc=expandIcon.src 'Returns the src attribute value
				If instr(strSrc, "treeUnexpand")>0 or instr(strSrc, "treeExpand")>0  Then ' Removed .* from condition because it was not working for some elements by Pavan kumar
					expandIcon.click
					'CME_resPassed='CME_resPassed+1
				    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					
				Else
					scrnShotTitle="ExpandIcon_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					On error goto 0
					Call CME_ExitTest() 		
				End If
			Else 
				scrnShotTitle="DealTreeElement_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				On error goto 0
				Call CME_ExitTest() 
			End If
		set expandIcon = Nothing
		set dealTreeBranch = Nothing

						
'********************************************************************
'Case name: CME_VerifyNumericValue
'Description: To verify field contains numeric value or not
'Created by : Pavan kumar
'Modified by and date:  Muzaffar A. 02/21/2019
'*********************************************************************	
	Case "CME_VerifyNumericValue" 
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		
		
		Set numericField=CME_application.WebElement(objDesc).WebEdit("visible:=true")
		If numericField.Exist(10)=True Then
			intFieldval=numericField.GetROProperty("value")
	  		If Ucase(Trim(Win_Title_Field))="READONLY" Then
	  			If numericField.Object.readOnly=True Then
	  				If IsNumeric(trim(intFieldval))=true Then
			  			ReportPassed(i)
			  			'CME_resPassed='CME_resPassed+1
					
					else
						scrnShotTitle="Value_Not_Found"
						Call CaptureFailedObject(CME_application, numericField, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			  		End If
			  	Else 
			  		scrnShotTitle="Field_NOT_ReadOnly"
					Call CaptureFailedObject(CME_application, numericField, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		  		End If
	  		Else 
	  			
		  		If IsNumeric(trim(intFieldval)) Then
		  			ReportPassed(i)
		  			'CME_resPassed='CME_resPassed+1
					
				else
					scrnShotTitle="Value_Not_Found"
					Call CaptureFailedObject(CME_application, numericField, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		  		End If
	  		End If
		Else  
			scrnShotTitle="Field_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		
  		
  		Set numericField=Nothing
  		
  		
  '********************************************************************
		'Case name: CME_HoverOnItem
		'Description: To Hover on particular element
		'Created by : Pavan 		'date:11/07/2019
		'*********************************************************************		
		Case "CME_HoverOnItem"
		
			Keyword = True
		    Tcs_Executed = Tcs_Executed+1
		    BoolfieldExist=False
		    On error resume next
		
			set element=CME_application.WebElement("html tag:=DIV|SPAN","class:=" & Win_Title_Field,"innertext:=" & field,"index:=0","visible:=true")
			BoolfieldExist=element.Exist(30)
			If BoolfieldExist=true Then
		    	element.HoverTap
		    	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		    Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				resFailed=resFailed+1
			End If
			set element=nothing		
  		
'********************************************************************
'Case name: CME_VerfiyCurrDate
'Description: To verify current date with credit report date generated in CME
'Created by : Pavan kumar
'Modified by and date: Pavan kumar , 02/05/2019
'*********************************************************************  		
  	Case "CME_VerfiyCurrDate" 
  		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		
		
		Set dateField=CME_application.WebElement(objDesc).WebEdit("visible:=true")
		
	    intFieldDate=dateField.GetROProperty("value")
	    
  		dtmMonth= month(date)
		dtmDay=day(date)
		dtmYear=year(date)
		If len(dtmMonth)=1 Then
			dtmMonth=0&dtmMonth
		else
			dtmMonth=dtmMonth		
		End If
		If  len(dtmDay)=1 Then
			dtmDay=0&dtmDay
		else
			dtmDay=dtmDay
		End If
		dtmDate=dtmMonth&"/"&dtmDay&"/"&dtmYear
		
		dtmDiffdate=DateDiff("d",intFieldDate,dtmDate)
	If dtmDiffdate=1 OR trim(intFieldDate)=trim(dtmDate) OR dtmDiffdate=0 Then		
		ReportPassed(i)
  		'CME_resPassed='CME_resPassed+1
	Else
		scrnShotTitle="CurrentDate_Not_Found"
		Call CaptureFailedObject(CME_application, objField, scrnShotTitle)
		CME_VerifyFieldValReportFailed(i)
		CME_resFailed=CME_resFailed+1
		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	End If
	
	Set dateField=Nothing


'********************************************************************
'Case name: CME_DDTStatus
'Description: To select DDT Status 
'Created by : Pavan kumar
'Modified by and date: 
'*********************************************************************

Case "CME_DDTStatus"
Set dropdownitem = CME_application.WebElement("html tag:=DIV","attribute/fieldname:=Status DD","visible:=true","index:=1").WebElement("html tag:=DIV","outerhtml:=.*ddButton.png.*", "visible:=true")
If dropdownitem.Exist(5) Then
	dropdownitem.Click
	CME_application.WebElement("html tag:=DIV","class:=gridBoxCell","innertext:="&field,"visible:=true").Click
End If



'********************************************************************
'Case name: CME_ValidateUser
'Description: To validate system user 
'Created by : Pavan kumar
'Modified by and date: Pavan Kumar , 02/05/2019
'*********************************************************************  

	Case "CME_ValidateUser" 
	    strSystemUser=Environment.Value("UserName")
	    strSysUser=left(strSystemUser,10)
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
   		Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		
		
		Set objField=CME_application.WebElement(objDesc).WebEdit("visible:=true")
		If objField.GetROProperty("attribute/fieldname")="use_last_initial" Then
			If objField.GetROProperty("attribute/readonly")<>1 Then
				scrnShotTitle="Field_Not_Readonly"
				Call CaptureFailedObject(CME_application, objField, scrnShotTitle)
				CME_VerifyFieldValReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		End If
	      strUserName=objField.GetROProperty("value")
	      strUser1=left(strUserName,10)
	      If  ucase(trim(strSystemUser))=ucase(trim(strUserName)) or ucase(trim(strSysUser))=ucase(trim(strUser1)) Then
	          ReportPassed(i)
	          'CME_resPassed='CME_resPassed+1
	        
		  Else
	      	scrnShotTitle="UserName_Not_Found"
			Call CaptureFailedObject(CME_application, objField, scrnShotTitle)
			CME_VerifyFieldValReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		  End If
		Set objField=Nothing
		
'********************************************************************
'Case name: CME_SelectCSIdoc
'Description: To sleect CSI document from the documents grid
'Created by : Automation 
'Modified by and date:
'********************************************************************* 		
	Case "CME_SelectCSIDocument" 
        Keyword=True
        CME_TS_Executed=CME_TS_Executed+1
        On error resume next
	   ''	Arg=field
	   	Set Odesc = Description.Create
		Odesc("class").Value = "gridBoxCell"
		Odesc("class Name").Value = "WebElement"
		Odesc("innertext").Value = value
		Set Objchild = CME_application.ChildObjects(Odesc)
		If Objchild.Count >= 1 Then
   			Objchild(0).Highlight
   			Objchild(0).Click
   			ReportPassed(i)
  		'CME_resPassed='CME_resPassed+1
	Else
		scrnShotTitle="CSI document_notfound"
	''	Call CaptureFailedObject(CME_application, objField, scrnShotTitle)
		CME_VerifyFieldValReportFailed(i)
		CME_resFailed=CME_resFailed+1
		Call CME_ExitTest() 
	End  If
'********************************************************************
'Case name: CME_VerifyDocText
'Description: To verify text value in credit bureau report in CME
'Created by : Pavan kumar
'Modified by and date: subhash Patil
'********************************************************************* 		
	Case "CME_VerifyDocText" 
        Keyword=True
        CME_TS_Executed=CME_TS_Executed+1
        On error resume next
	   	Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
	
        Set txtfield=CME_application.WebElement(objDesc).WebEdit("visible:=true")
        strval=txtfield.getroproperty("value")
        
        If instr(ucase(strval),ucase(value))>0 Then            
            ReportPassed(i)
            'CME_resPassed='CME_resPassed+1
        else
          	scrnShotTitle="Value_Not_Found"
			Call CaptureFailedObject(CME_application, txtfield, scrnShotTitle)
            CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
            'CME_FetchResultStatusAndEnterinFinalResults(resPath) 
        End If
    Set txtfield=Nothing
    Set objDesc = Nothing
        
        
'********************************************************************
'Case name: CME_VerifyPDFdoc
'Description: For verifying pdf data of credit report generated in new window
'Created by : Pavan kumar
'Modified by and date: Muzaffar A. 11/01/2018
'*********************************************************************        
			
	Case "CME_VerifyPDFdoc" 
        Keyword=True
        'CME_TS_Executed=CME_TS_Executed+1
        boolPageExist=false
        On error resume next
        wait 2
       Call CME_DynamicWait()
      Call CME_CSi_PopUP()
       Call RefreshPDFPage()

		Set pdfPage=Browser("Creationtime:=1").WinObject("regexpwndtitle:=AVPageView","visible:=True")
		strTitle=pdfPage.GetROProperty("title")
		If pdfPage.Exist(20)=True AND Right(UCase(strTitle), 4) = ".PDF" OR ".HTM" Then
			If Trim(value) <> "" Then
				set oShell=createobject("WScript.shell")
				Set fso=CreateObject("Scripting.FileSystemObject")
				'docFilePath = "C:\Users\"& Environment.Value("UserName") &"\Documents\pdfContent.txt"
				'docFilePath = "\\nterprise.net\bankdata\CMESPITestData\CME_RuntimeDocs\" & CME_Get_TC_Title &"_pdfContent.txt"	
				'set txtFile=fso.CreateTextFile(docFilePath, True)
			    Set oClipBoard=CreateObject("Mercury.Clipboard")
				pdfPage.highlight 'Bringing PDF page to focus
			    oShell.SendKeys "^a"
			 	wait 1
			  	oShell.SendKeys "^c"
			  	wait 1
			   ' txtFile.Write(oClipBoard.GetText)
			''	set txtFile=fso.OpenTextFile(docFilePath,1, True)
				'strPDFcontent=txtFile.ReadAll
				'strPDFcontent = strPDFcontent.GetText
				strPDFcontent = oClipBoard.GetText
		''	msgbox strPDFcontent
			If instr(ucase(strPDFcontent),ucase(value))>0 Then
		
			        Call CaptureScreen("")
			        CME_ReportScreenshot(i)
			        'CME_resPassed='CME_resPassed+1
		    	Else
			    	scrnShotTitle=value&"_Value_Not_Found"
					Call CaptureScreen(scrnShotTitle)
			        CME_ReportFailed(i)
			        CME_resFailed=CME_resFailed+1
			        'CME_FetchResultStatusAndEnterinFinalResults(resPath) 
		    	End If	
				Call CloseAllBrowsersExceptCME()	
			Else 
				Call CloseAllBrowsersExceptCME()
			End If
			
			strPDFcontent = ""
			set txtFile=Nothing
			Set oClipBoard=Nothing
			Set fso=Nothing
			set oShell=Nothing

		Else 
			scrnShotTitle="PDF_Not_Found"
			Call CaptureScreen(scrnShotTitle)
		    CME_ReportFailed(i)
		    CME_resFailed=CME_resFailed+1
		    'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'		   	On error goto 0
'		    Exittest
		End If
		
		

'********************************************************************
'Case name: CME_Verify_FieldVal_in_PDF
'Description: For verifying dynamic field value in PDF document
'Created by : Muzaffar A. 11/01/2018
'Modified by and date: 
'*********************************************************************    
	Case "CME_Verify_FieldVal_in_PDF" 
       Keyword=True
        CME_TS_Executed=CME_TS_Executed+1
        On error resume next
		set oShell=createobject("WScript.shell")
		Set fso=CreateObject("Scripting.FileSystemObject") 
		'docFilePath = "C:\Users\"& Environment.Value("UserName") &"\Documents\pdfContent.txt"
		docFilePath = "\\nterprise.net\bankdata\CMESPITestData\CME_RuntimeDocs\" & CME_Get_TC_Title &"_pdfContent.txt"
		set txtFile=fso.OpenTextFile(docFilePath,1, True)
		strPDFcontent=txtFile.ReadAll
		If UCase(Trim(Win_Title_Field)) = "DYNAMIC" Then
			valFromGlobalVar = CME_FetchValueFromGlobalVariable(value) 'Fetching Global Variables file
			strExpected = field &" "& Environment.Value(valFromGlobalVar)
			If instr(ucase(strPDFcontent),ucase(strExpected))>0 Then
		        ReportPassed(i)
		        'CME_resPassed='CME_resPassed+1
	    	Else
		    	scrnShotTitle="Value_Not_Found"
				Call CaptureScreen(scrnShotTitle)
		        CME_ReportFailed(i)
		        CME_resFailed=CME_resFailed+1
	    	End If		
		Else 
			strExpected = field &" "& value
			If instr(ucase(strPDFcontent),ucase(strExpected))>0 Then
		        ReportPassed(i)
		        'CME_resPassed='CME_resPassed+1
	    	Else
		    	scrnShotTitle="Value_Not_Found"
				Call CaptureScreen(scrnShotTitle)
		        CME_ReportFailed(i)
		        CME_resFailed=CME_resFailed+1
	    	End If		
		End If
		
		set txtFile=Nothing
		Set fso=Nothing
		set oShell=Nothing



'********************************************************************
'Case name: CME_Download_PDF
'Description: For downloading PDF document from browser
'Created by : Muzaffar A. 11/14/2019
'Modified by and date: 
'*********************************************************************    
	Case "CME_Download_File" 
        Keyword=True
        CME_TS_Executed=CME_TS_Executed+1
        On error resume next
        docFilePath = "\\nterprise.net\Bankdata\QA\CME_Automation\DOCS\" & value
        Call CME_SavePDFfromBrowser(docFilePath)
        
 '********************************************************************
'Case name: CME_Download_PDF
'Description: For downloading PDF document from browser
'Created by : Muzaffar A. 11/14/2019
'Modified by and date: 
'********************************************************************* 
	Case "CME_Delete_File" 
        Keyword=True
        CME_TS_Executed=CME_TS_Executed+1
        On error resume next
        docFilePath = "C:\Users\"& Environment.Value("UserName") &"\Documents\" & value
        dim filesys
		Set filesys = CreateObject("Scripting.FileSystemObject")
		If filesys.FileExists(docFilePath) Then
			filesys.DeleteFile(docFilePath)
		Else 
			Reporter.ReportEvent micFail, docFilePath, " Not Found"
		End If
		
		Set filesys = Nothing
'********************************************************************
'Case name: CME_NAICS_search
'Description: For NAICS search  and to validate search result
'Created by : Pavan kumar
'Modified by and date: Muzaffar A.
'*********************************************************************

    Case "CME_NAICS_search" 
    Keyword=True
    CME_TS_Executed=CME_TS_Executed+1
    BoolfieldExist=False
    On error resume next
	set NAICS_SearchTab=CME_application.WebElement("html tag:=DIV","class:=container","innertext:=.*NAICS Search.*","visible:=true") 'accessing NAICS search window 
	BoolfieldExist=NAICS_SearchTab.Exist(5)
	If BoolfieldExist=True Then
			NAICS_SearchTab.Object.getElementsByTagName("INPUT")(0).Value=value
			NAICS_SearchTab.WebElement("html tag:=A","innertext:=Search","visible:=true").Click
			NAICS_SearchTab.WebElement("html tag:=A","innertext:=Search","visible:=true").Click
			wait 3
			'We can either search by NAICS code number or description
			If IsNumeric(trim(value))=true Then
				SearchVal=NAICS_SearchTab.WebElement("html tag:=DIV","class:=gridBoxCell","visible:=true","index:=0").GetROProperty("innertext")
			ElseIf IsNumeric(value)=false And Typename(value)=String Then
				SearchVal=NAICS_SearchTab.WebElement("html tag:=DIV","class:=gridBoxCell","visible:=true","index:=1").GetROProperty("innertext")
			End If
			
			If trim(value)=trim(SearchVal) Then
	 			ReportPassed(i)
        		'CME_resPassed='CME_resPassed+1
     	 	else
      			scrnShotTitle="Value_Not_Found"
				Call CaptureFailedObject(CME_application, NAICS_SearchTab, scrnShotTitle)
       			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
        		CME_resFailed=CME_resFailed+1
	 		End If
     else
          	scrnShotTitle="NAICS_SearchTab_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
            CME_resFailed=CME_resFailed+1
            On error goto 0
            Call CME_ExitTest() 		
	End If
	set NAICS_SearchTab=nothing 


'********************************************************************
'Case name: CME_VerifyValue
'Description: To verify values
'Created by : Automation Team
'Modified by and date: 
'*********************************************************************	
	 Case "CME_VerifyValue"
		Keyword=True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		no_units=CME_application.webelement("attribute/fieldname:=cpool_units","visible:=true").Webedit("html tag:=input").GetROProperty("title")
		unit_price=CME_application.webelement("attribute/fieldname:=cpool_unit_value","visible:=true","index:=0").Webedit("html tag:=input").GetROProperty("title")
		val=cint(no_units)*cint(unit_price)
		toatalval=FormatNumber(val,2)
		valin_field=CME_application.webelement("attribute/fieldname:=cpool_value","visible:=true","index:=0").Webedit("html tag:=input").GetROProperty("title")
		If trim(toatalval)=trim(valin_field) Then
			ReportPassed(i)
			'CME_resPassed='CME_resPassed+1
		else
			scrnShotTitle="Expected_Value_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			CME_resFailed=CME_resFailed+1
				
		End If


'********************************************************************
'Case name: CME_InfoPopup
'Description: To Handle Info pop ups
'Created by : Shruthi Aila
'Modified by and date: Subhash Patil/Muzaffar A. 10/19/2018
'*********************************************************************

		Case "CME_InfoPopup" 
		Keyword = True			
		CME_TS_Executed=CME_TS_Executed+1	
		BoolfieldExist=False
		On error resume next
		BoolfieldExist=CME_application.WebElement("class:=container","innertext:=Information.*","visible:=True").Image("file name:=\?_twr_=info\.png|\?_twr_=warning\.png","visible:=true").Exist(10)
				
		If BoolfieldExist=true Then
			Call CME_InfoPopup()
		Else 
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 
		End If
		
'********************************************************************
'Case name: CME_Popup
'Description: To Handle Info pop ups
'Created by : Muzaffar A.
'Modified by and date:
'field = Pop Up logical name from OR
'value = button needs to be clicked (For Ex: Yes/No)
'*********************************************************************		
Case "CME_PopUp"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 
		
		Call CME_DynamicWait()
		
		Set popUp = CME_application.WebElement(objDesc) ' Modified by Muzaffar A. 
		If popUp.exist(60) Then
			set popUpBtn = CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:="&value, "visible:=true", "index:=0")
			If popUpBtn.Exist(10) Then
				popUpBtn.Click
				'ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle="Button_Not_Found"
            	Call CaptureFailedObject(CME_application, popUpBtn, scrnShotTitle)
		    	CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
		 		On error goto 0
				Call CME_ExitTest() 
			End If
		Else 
	   		scrnShotTitle="PopUp_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 
	  
		End If
		
		Set popUp = Nothing
		Set objDesc = Nothing
		
'********************************************************************
'Case name: CME_Verify_ErrorMsg
'Description: To Handle Error Messages
'Created by : Divya V C
'Modified by and date: 
'*********************************************************************		
		
		Case "CME_Verify_ErrorMsg" 
		Keyword = True			
		CME_TS_Executed=CME_TS_Executed+1	
		BoolfieldExist=False
		On error resume next
		Set errIcon=CME_application.Image("file name:=\?_twr_=error\.png","visible:=true")	
		BoolfieldExist=errIcon.Exist(5)

		If BoolfieldExist=true Then
			Set errMsg=CME_application.WebElement("html tag:=DIV","class:=label","innertext:=" & value & ".*","visible:=true")
			If errMsg.Exist(5) Then
				ReportPassed(i)
        		'CME_resPassed='CME_resPassed+1
        	Else
				scrnShotTitle="ErrorMessage_Not_Found"
				Call CaptureScreen(scrnShotTitle)        	
        		CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		Else
			scrnShotTitle="ErrorMessage_Not_Found"
			Call CaptureScreen(scrnShotTitle)      		
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If

'********************************************************************
'Case name: CME_RecScen_MultipleEnts
'Description: 
'Created by :
'Modified by and date:
'*********************************************************************
	    Case "CME_RecScen_MultipleEnts"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    Call CME_CSA_EntityInfo_RecScen()





'********************************************************************
'Case name: CME_Verify_NoErrorMsg
'Description: To Handle when there is no Error Messages
'Created by : Divya V C
'Modified by and date: 
'*********************************************************************		
				
		Case "CME_Verify_NoErrorMsg" 
		Keyword = True			
		CME_TS_Executed=CME_TS_Executed+1	
		BoolfieldExist=False
		On error resume next	
		Set errIcon=CME_application.Image("file name:=\?_twr_=error\.png","visible:=true")	
		BoolfieldExist=errIcon.Exist(5)
	
		If BoolfieldExist=false Then
			ReportPassed(i)
    		'CME_resPassed='CME_resPassed+1
        	
		Else 
			scrnShotTitle="ErrorMessage_Found"
			Call CaptureFailedObject(CME_application, errIcon, scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If

		
'********************************************************************
'Case name: CME_HandleCsiPopUps
'Description: To Handle CSi pop ups
'Created by : Pavan kumar
'Modified by and date:Subhash Patil 
'*********************************************************************
		Case "CME_HandleCsiPopUps" 
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    On error resume next	
			Call CME_CSi_PopUP()


'********************************************************************
'Case name: CME_HandleSavePopUps
'Description: 
'Created by : Subhash Patil
'Modified by and date: 
'*********************************************************************
		Case "CME_HandleSavePopUps" 
	    Keyword = True
	 		'/Defining a boolean variable
		boolCsiPopExist=False
		'/Checking for CSi Pop up in the Sreen
		Call CME_DynamicWait()
		Set popBtn = CME_application.WebElement("class:=button","html tag:=DIV","attribute/fieldName:="&field, "visible:=True", "index:=0").WebElement("html tag:=A","innertext:="&field,"visible:=True", "index:=0")
  		
  		boolCsiPopExist=popBtn.Exist(3)
        If boolCsiPopExist then
            '/clicking the OK  button
            popBtn.Highlight
            'wait 2
            popBtn.Click
        
        End If
    	Set popBtn=Nothing
    	
  
 '********************************************************************
'Case name: CME_DDTScreen_Officers
'Description: To Handle DDT Screen
'Created by : Divya V C
'Modified by and date: 
'*********************************************************************
		Case "CME_DDTScreen_Officers"  
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		Call CME_DDTScreen()
		

'********************************************************************
'Case name: CME_DDTScreen
'Description: To Handle DDT Screen
'Created by : Divya V C
'Modified by and date: 
'*********************************************************************

		Case "CME_DDTScreen"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1
		'// Handling screen load
		Call CME_CSi_PopUP()
		call CME_DynamicWait()
		set gridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=Results GridBox","visible:=true")
		If gridBox.Exist(20) Then
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set colDocName=gridBox.WebElement("class:=gridBoxColumn","index:=3","visible:=true")	'Document Name column			
			Set colDocNameContent=colDocName.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rcDocName=colDocNameContent.Count 'Getting the rowcount of the Document Name column
						
			Set colRelTo=gridBox.WebElement("class:=gridBoxColumn","index:=9","visible:=true")	'Assigned To column			
			Set colRelToContent=colRelTo.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rcRelTo=colRelToContent.Count 'Getting the rowcount of the Assigned To column
			If rcRelTo=rcDocName Then
				gridRowCount=rcDocName
			End If
	
			'// Deal Activity Status Object
			Set objstatusField = CME_application.WebElement("html tag:=SPAN","class:=treeRow").WebElement("html tag:=SPAN", "innertext:=.* - Status: .*", "visible:=true", "index:=0")
			If objstatusField.Exist(5) = False Then
				'// Report Deal Activity Status Field Not Found
				scrnShotTitle="ActivityStatusField_NOTFound"
				Call CaptureScreen(scrnShotTitle)      		
				CME_ReportFailed(i)
				On Error goto 0
				Call CME_ExitTest()  
			Else 
				strActSts = objstatusField.GetROProperty("innertext")
			End If 
			'// Assigned To drop down
			Set asgndDD = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=Assigned To DD").WebEdit("visible:=true")
			If asgndDD.Exist(5) = False Then
				'// Report Assigned To DD Not Found
				scrnShotTitle="AssignedDD_NOTFound"
				Call CaptureScreen(scrnShotTitle)      		
				CME_ReportFailed(i)
				On Error goto 0
				Call CME_ExitTest() 
			End If 
			'// Status Drop down
			Set stsDD = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldname:=Status DD","index:=1","visible:=true").WebEdit("visible:=true")
			If stsDD.Exist(5) = False Then
				'// Report Status Drop down Field Not Found
				scrnShotTitle="StatusDD_NOTFound"
				Call CaptureScreen(scrnShotTitle)      		
				CME_ReportFailed(i)
				On Error goto 0
				Call CME_ExitTest()  
			End If 
			If gridRowCount<>0 Then
			
				For iDDT = 0 To gridRowCount-1 
				'Msgbox iDDT
					'// Reading Doc name
					docName=Trim(colDocNameContent(iDDT).GetROProperty("innertext"))
					'msgbox docName
					'// Reading Assigned To 
					offName=Trim(colRelToContent(iDDT).GetROProperty("innertext"))
					
					If Trim(offName) = "" Then 'When Assigned To column is empty
						'// Assigning doc to user when condition is met
						
						colRelToContent(iDDT).Click
						wait 1
'						asgndDD.Click
'						wait 0.5
'						CME_application.WebElement("class:=gridBoxCell","innertext:=.* Loan Admin","index:=0","visible:=true").Click
'						wait 1
'						asgndDD.Click
'						asgndDD.object.value=value
'						wait 0.5
				        asgndDD.Click
					
						set usrgridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=","innertext:=emp_namerole_type.*")
						usrgridBox.WebElement("class:=gridBoxCell","innertext:=.* Loan Admin").Click
						
						asgndDD.Click
						wait 1
						If asgndDD.GetROProperty("value") = "" Then
							wait 1
							set usrgridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=","innertext:=emp_namerole_type.*")
							usrgridBox.WebElement("class:=gridBoxCell","innertext:=.* Loan Admin").Click
							
							asgndDD.DoubleClick
						End If
						wait 1
					End If	
					
					'// When Activity Status is Due Diligence
					If Instr(LCase(strActSts), "due diligence") > 0 Then
						If Trim(docName) = "OFAC Search" or Trim(docName)="RLOC to Term" or Trim(docName)="Territorial Concurrence" or  Trim(docName)= "UCC Search" or Trim(docName)="Flood Hazard Determination" or Trim(docName)="Appraisal - Real Estate" or Trim(docName)="Appraisal - Chattel Property/Equipment" or Trim(docName) = "Title Commitment" Then
						statusStr = "Completed"
'						ElseIf Trim(docName) = "Title Commitment" Then									
'							statusStr = "Requested"	
						End If
					
					ElseIf Instr(LCase(strActSts), "status: pre-decision review") > 0 Then	
						If Trim(docName) = "Pre Decision Review" Then
						statusStr = "Completed"
						
						End If
					'// When Activity Status is Closing Doc Execution
					
					ElseIf Instr(LCase(strActSts), "closing doc execution") > 0 Then	
						If Trim(docName) = "Executed Closing Documents" Then
						statusStr = "Completed"
						
						End If
						
					'// When Activity Status is Closing Fund/Book
					
					ElseIf Instr(LCase(strActSts), "closing fund/book") > 0 Then	
						If Trim(docName) = "Onboarding to Loan IQ" Then
						statusStr = "Completed"
						
						End If	
					'// When Activity Status is Post Closing
					
					ElseIf Instr(LCase(strActSts), "post-closing") > 0 Then	
						If Trim(docName) = "Title Insurance Policy" or Trim(docName) = "Recorded Deed of Trust" Then
						statusStr = "Completed"
						
						End If
					'// When Activity Status is Post Closing RE Certification
					'msgbox strActSts
					ElseIf Instr(LCase(strActSts), "post-closing re certification") > 0 Then	
					
						If Trim(docName) = "RE Collateral Loan Certification" Then
						statusStr = "Completed"
						
						End If
					
					
					Else 
						statusStr = ""
					End If
					
					'// When Condition is met Selecting Status for the document
					If statusStr <> "" Then
						colDocNameContent(iDDT).Click
						wait 1
						stsDD.Object.Value = statusStr
						wait 0.5
						stsDD.DoubleClick
						
					End If
			'		strpro=CME_application.WebElement("attribute/fieldname:=Product DD").WebEdit("html tag:=input","visible:=true").GetROProperty("title")
			'		If strpro="" Then
			'   			set prodDD=CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=Product DD","index:=0").WebEdit("visible:=true")
			'   	  	 	
			'	   		If prodDD.Exist(5) = True Then
			'		   		prodDD.Click
			'		   		wait 0.5
			'		 		Set dropDownItem=CME_application.WebElement("html tag:=DIV","class:=gridBoxCell","innerhtml:=Facility #1 .*","visible:=true") '
			'            	dropDownItem.Fireevent "onclick"
			'			Else 
			'				msgbox "Product Drop down not found"
			'	 		End If
			' 		End If
					Next
				End If
		Else 
			'// Report DDT Grid Not Found
			scrnShotTitle="DDTGrid_NOTFound"
			Call CaptureScreen(scrnShotTitle)      		
			CME_ReportFailed(i)
			On Error goto 0
			Call CME_ExitTest()  
		End If 
		
		Call CaptureScreen(scrnShotTitle)
	    CME_ReportScreenshot(i)
		
		
		set usrgridBox=Nothing
		Set stsDD = Nothing
		Set asgndDD = Nothing
		Set objstatusField = Nothing
		Set objstatusField = Nothing

		
'********************************************************************
'Case name: CME_ClickListBox
'Description: To Handle list box
'Created by : subhash patil
'Modified by and date: Muzaffar A. 01/31/2019
'*********************************************************************		

		Case "CME_ClickListBox" 
			Keyword = True
		    Tcs_Executed = Tcs_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    If Trim(Win_Title_Field)="" Then
		    	Arg=field
				propVal=CME_Value_from_Repository(Arg,"Value")
			   	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
				Set objDesc = Description.Create 'Creating description for the object
				For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
					If arr(1) <> "" Then 
						objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
					End If				
				Next
				objDesc("visible").Value=true 'Adding Visible property to collection of description
					''set LstBox=CME_application.WebElement(objDesc).WebElement("outerhtml:=.*ddButton.png.*")
			   	set LstBox=CME_application.WebElement(objDesc).WebElement("outerhtml:=.*ddButton.png.*","html tag:=DIV","index:=0")
		    	BoolfieldExist=LstBox.Exist(5)
			    If BoolfieldExist=True Then
			    Setting.Webpackage("Replaytype") = 2
				    LstBox.Click
				Setting.Webpackage("Replaytype") = 1
					'CME_resPassed='CME_resPassed+1
			    	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"				    
				ElseIf BoolfieldExist=False Then
					scrnShotTitle="ListBox_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
				
		    ElseIf Ucase(Trim(Win_Title_Field))="NOFIELDNAME" Then
		    	Set label=CME_application.WebElement("class:=label","attribute/fieldName:="& field,"visible:=true","index:=0")
			  	If label.Exist(5) Then
			  		Set LstBox=label.Object.NextSibling.firstchild.NextSibling
			  		LstBox.Click
			  	Else 
			  		scrnShotTitle="Label_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
		    End If
		    Set LstBox=nothing
		    

'********************************************************************
'Case name: CME_Searchdeal
'Description: To search deal number
'Created by : Pavan kumar 
'Modified by and date: 
'*********************************************************************		
       
       Case "CME_Searchdeal" 
       Keyword = True
       CME_TS_Executed=CME_TS_Executed+1
       BoolfieldExist=False
	   On error resume next
       Set objWsh=Createobject("Wscript.shell") 
       set intDealnum=CME_application.WebElement("Attribute/fieldName:=Go to Deal Number").WebEdit("visible:=True")
       
       BoolfieldExist=intDealnum.Exist(10)
       If BoolfieldExist=True Then
		   intDealnum.Click
		   intDealnum.Set value
		   objWsh.SendKeys "{ENTER}"
		   'CME_resPassed='CME_resPassed+1
      	   
       Else 
       		scrnShotTitle="SearchBox_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
            On error goto 0
            Call CME_ExitTest() 
       End If
       Set objWsh=Nothing 
       wait 7
       

'********************************************************************
'Case name: CME_SendKeys
'Description: To send values using sendkeys
'Created by : Divya V C 
'Modified by and date: Muzaffar A
'*********************************************************************	
	Case "CME_SendKeys" 
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		On error resume next
		Set objWsh=Createobject("Wscript.shell") 
		CME_application.FireEvent "onfocus"
		   objWsh.SendKeys "{"& Trim(UCase(field)) & "}" 'We can give the Key name in the value column
		   Set objWsh=Nothing
		'CME_resPassed='CME_resPassed+1

       

       
'********************************************************************
'Case name: CME_SendKeysSingleCheckbox
'Description: To select values in dropdown using sendkeys
'Created by : Subhash Patil
'Modified by and date: 
'*********************************************************************       
	Case "CME_SendKeysSingleCheckbox"			
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		Set objWsh=Createobject("Wscript.shell")
		set LstBox=CME_application.WebElement(objDesc).WebEdit("visible:=True")
		BoolfieldExist=LstBox.Exist(5)
		If BoolfieldExist=True Then
			LstBox.Click
			set mySendKeys = CreateObject("WScript.shell")
			mySendKeys.SendKeys("{DOWN}")
			wait 1
		  	objWsh.SendKeys " "
		  	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"				    
		Else
			scrnShotTitle="ListBox_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		  
		set mySendKeys = Nothing  
		set LstBox=Nothing  
		Set objWsh = Nothing
		Set objDesc = Nothing	      
       
'********************************************************************
'Case name: CME_SendKeysSpace
'Description: To click space bar
'Created by : Pavan kumar 04/12/2019
'Modified by and date: 
'*********************************************************************       
      		   Case "CME_SendKeysSpace"		
			   Keyword = True
		       CME_TS_Executed=CME_TS_Executed+1
		       Set objWsh=Createobject("Wscript.shell") 
		       objWsh.SendKeys " "
			   'CME_resPassed='CME_resPassed+1
			   Set objWsh = Nothing
			      
			      
			      			
'********************************************************************
'Case name: CME_PleaseWait
'Description: Waits for the "Please Wait browsing cycle dialog" to disappear
'Created by : Subhash Patil 
'Modified by and date:
'*********************************************************************

	Case "CME_PleaseWait"

		Keyword = True
	    Tcs_Executed = Tcs_Executed+1 
	    On error resume next
	    If Lcase(Trim(field)) = "covenants" Then
	    	Call CME_DynamicWait()
	    	Set waitImg = CME_application.Image("class:=image","html tag:=IMG","file name:=\?_twr_=wait\.png","visible:=True")
			If waitImg.Exist(1) Then
				wait 2
			
			End If
	    
'	    	Set gridcell=description.Create
'			gridcell("micClass").Value="WebElement"
'			gridcell("class").Value="gridBoxCell"
'			gridcell("innertext").Value="N"
'			'gridcell("innerhtml").Value=".*gbChecked.png.*"
'			gridcell("visible").Value=true
'			Set listContent=CME_application.WebElement("class:=gridBox","attribute/fieldName:=gbCovs","visible:=true").WebElement("class:=gridBoxColumn","visible:=true","index:=2")
'			'listContent.Highlight
'			Set items=listContent.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
'			rowcount=items.Count'Getting the rowcount of the grid
'			
'			If lcase(Trim(items(rowcount-1).GetROProperty("innertext"))) = "complete" Then
'				rdyFlg = True
'			Else 
'				rdyFlg = False
'			End If
'	
'			For iflg = 0 To 10
'				If rdyFlg Then
'					Exit For
'				Else 
'					wait 2
'				End If
'			Next
'				
'			
'			Set items=Nothing
'			Set listContent=Nothing
'			Set gridcell=Nothing
				
			ElseIf Ucase(Trim(field)) = "DDT" Then
	    
		    	Do Until Not CME_application.WebElement("html tag:=A", "innertext:=Due Diligence Tracking", "index:=0").Exist(1)
				
				Loop 
	    	
	   		End If
	    
	    Call CME_DynamicWait()



'********************************************************************
'Case name: CME_AngJS_PleaseWait
'Description: Waits for the "Please Wait browsing cycle dialog" to disappear
'Created by : Subhash Patil 
'Modified by and date:
'*********************************************************************

	Case "CME_AngJS_PleaseWait"

		Keyword = True
	    Tcs_Executed = Tcs_Executed+1 
	    On error resume next
		Set objPlsWait = CME_application.WebElement("class:=click-blocker","html tag:=DIV","visible:=True","index:=0")

		Do while  objPlsWait.Exist(1)
			wait 1
			
		Loop		       
	    set objPlsWait=nothing
		
		'Set excErr = CME_application.WebElement("class:=font-data","html tag:=PRE","innertext:=An exception has occured in the application.*","visible:=True","index:=0")
		Set er = CME_application.WebElement("class:=modal-content","visible:=True","index:=0")
		If er.Exist(1) Then
			errMsgFlg = er.GetROProperty("innertext")
			If Instr(UCase(errMsgFlg), "ERROR") > 0 Then
				scrnShotTitle="Error"
				Call CaptureScreen(scrnShotTitle)
				Field = "Error"
				testdescription = "Error"
				CME_ReportFailed(i)
	            CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest() 
			End If 
			
		End If
		
		Set excErr = nothing
'********************************************************************
'Case name: CME_SendKeysTwoCheckboxes
'Description: To select values in dropdown using sendkeys
'Created by : Subhash Patil
'Modified by and date: 
'********************************************************************* 
       Case "CME_SendKeysTwoCheckboxes"		
		      Keyword = True
			CME_TS_Executed=CME_TS_Executed+1
			On error resume next
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description
			Set objWsh=Createobject("Wscript.shell")
			set LstBox=CME_application.WebElement(objDesc).WebEdit("visible:=True")
			BoolfieldExist=LstBox.Exist(5)
			If BoolfieldExist=True Then
				LstBox.Click
				set mySendKeys = CreateObject("WScript.shell")
				mySendKeys.SendKeys("{DOWN}")
				wait 0.5
				mySendKeys.SendKeys("{DOWN}")
				wait 1
			  	objWsh.SendKeys " "
			  	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"				    
			Else
				scrnShotTitle="ListBox_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			  
			set mySendKeys = Nothing  
			set LstBox=Nothing  
			Set objWsh = Nothing
			Set objDesc = Nothing	      
			       

       
'********************************************************************
'Case name: CME_SendKeys_Tab
'Description: To send Tab
'Created by : Muzaffar A
'Modified by and date: 
'********************************************************************* 		       
       
       Case "CME_SendKeys_Tab" 
       Keyword = True
       CME_TS_Executed=CME_TS_Executed+1
       Set objWsh=Createobject("Wscript.shell") 
   	   objWsh.SendKeys "{TAB}"
       'CME_resPassed='CME_resPassed+1
       Set objWsh=Nothing
 
'********************************************************************
'Case name: CME_WebEdit_No_FieldName
'Description: To enter values for text fields which dont have field names
'Created by : Muzaffar A
'Modified by and date: 
'********************************************************************* 
       
       Case "CME_WebEdit_No_FieldName" 

			Keyword = True
		  	CME_TS_Executed=CME_TS_Executed+1
		  	BoolfieldExist=False
		  	On error resume next
		  	Set label=CME_application.WebElement("attribute/fieldName:="& field,"visible:=true","index:=0")
		  	If label.Exist(10) Then
		  		Set objWebEdit=label.Object.PreviousSibling.lastchild
				If ucase(Win_Title_Field)="VERIFY" Then
					strFieldval=objWebEdit.Value
					If ucase(trim(value))=ucase(trim(strFieldval)) Then
				   		 ReportPassed(i)
				   		 'CME_resPassed='CME_resPassed+1
				   	Else 
				   		scrnShotTitle="Value_Not_Found"
						Call CaptureFailedObject(CME_application, objWebEdit, scrnShotTitle)
				   		CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				ElseIf ucase(Win_Title_Field)="VERIFY_WEBLEMENT" Then
					Set objWebEl = label.Object.PreviousSibling
					strFieldval = objWebEl.Innertext
					If ucase(trim(value))=ucase(trim(strFieldval)) Then
				   		 ReportPassed(i)
				   		 'CME_resPassed='CME_resPassed+1
				   	Else 
				   		scrnShotTitle="Value_Not_Matched"
						Call CaptureFailedObject(CME_application, objWebEl, scrnShotTitle)
				   		CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If					
				ElseIf ucase(Win_Title_Field)="ENTER" Then
					objWebEdit.Value=value
					Set objWebEdit=CME_application.WebEdit("value:="&value,"visible:=true","index:=0")
					objWebEdit.Click
					ReportPassed(i)
				   	'CME_resPassed='CME_resPassed+1
				ElseIf ucase(Win_Title_Field)="VERIFY_READONLY" Then
					If objWebEdit.GetROProperty("atribute/readonly")=1 Then
						strFieldval=objWebEdit.Value
						If ucase(trim(value))=ucase(trim(strFieldval)) Then
					   		 ReportPassed(i)
					   		 'CME_resPassed='CME_resPassed+1
					   	Else 
					   		scrnShotTitle="Value_Not_Found"
							Call CaptureFailedObject(CME_application, objWebEdit, scrnShotTitle)
					   		CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1
							'CME_FetchResultStatusAndEnterinFinalResults(resPath)
						End If
					Else 
						scrnShotTitle="Field_Not_Readonly"
						Call CaptureFailedObject(CME_application, objWebEdit, scrnShotTitle)
				   		CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
					
				End if 
			Else 
				scrnShotTitle="Field_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				
		  	End If
		  	
		Set objWebEdit=Nothing
		Set label=Nothing
		
		
'********************************************************************
'Case name: CME_GuideLineCompliance
'Description: To select values using sendkeys
'Created by : Divya V C
'Modified by and date: 
'********************************************************************* 

	Case "CME_GuideLineCompliance"
		Keyword = True
		Tcs_Executed=Tcs_Executed+1
		If Trim(ucase(Win_Title_Field))="LTV" Then
			Set fieldLabel = CME_application.WebElement("class:=label", "innertext:=Is LTV Less Than or Equal To .*", "index:=0","visible:=true")
		ElseIf Trim(ucase(Win_Title_Field))="AGFAST_SCORE" Then 
			Set fieldLabel = CME_application.WebElement("class:=label", "innertext:=Is AgFast Score Greater Than or Equal To.*", "index:=0","visible:=true")
		ElseIf Trim(ucase(Win_Title_Field))="LOAN_TERMS" Then 
			Set fieldLabel = CME_application.WebElement("class:=label", "innertext:=Is Loan Terms Less Than or Equal To 360 Months.*", "index:=0","visible:=true")
		End If
		
		Set RB_Yes = fieldLabel.Object.NextSibling
		Set RB_No = RB_Yes.NextSibling
		Set RB_NA = RB_No.NextSibling
		
		If InStr(RB_Yes.Outerhtml, "Radio_checked") > 0 Then
			field = Win_Title_Field
			ReportPassed(i)
		ElseIf InStr(RB_No.Outerhtml, "Radio_checked") > 0 Then
			Set ovrdTxtArea = RB_NA.NextSibling
			If UCase(ovrdTxtArea.ClassName) = "TEXTAREA" Then
				Set TxtArea = ovrdTxtArea.LastChild
				TxtArea.Value = value
				TxtArea.Click
			Else 
				'Report textarea not found
				scrnShotTitle="Textarea_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
			End If
			If UCase(ovrdTxtArea.NextSibling.ClassName) = "DROPDOWNGRIDBOX" Then
				Set justifCode = ovrdTxtArea.NextSibling.firstchild.NextSibling
				justifCode.Click
				wait 1
				CME_application.WebElement("class:=gridBoxCell", "innertext:=Strong Bank Relationship", "index:=0","visible:=true").Click
				wait 1
				Set WshShell = CreateObject("WScript.Shell")
				WshShell.SendKeys "{TAB}" 'Unexpanding the drop down list
				Set WshShell=Nothing
			Else 
				scrnShotTitle="JustificationCode_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
			End If
		Else 
			scrnShotTitle="LTV_RadioButton"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If

'********************************************************************
'Case name: CME_SelectGuideCompl_RB_Yes
'Description: To select values using sendkeys
'Created by : Muzaffar A.
'Modified by and date: 
'********************************************************************* 

	Case "CME_SelectGuideCompl_RB_Yes"
		Call CME_DynamicWait()
		Keyword = True
		Tcs_Executed=Tcs_Executed+1
		On error resume next
		Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")

		Set scr =  CME_application.WebElement("class:=container", "attribute/fieldName:=SysGen_GC", "visible:=true")
		
		Set objDesc = description.Create
		objDesc("class").value = "radioButton"
		objDesc("html tag").value = "A"
		objDesc("innertext").value = "Yes"
		objDesc("visible").value = True
		
		
		Set rbArr = scr.ChildObjects(objDesc)
		'Selecting Yes to all radio buttons in the screen
		For irb = 0 To rbArr.count - 1
			checked=rbArr(irb).GetRoProperty("innerhtml")
			If NOT Instr(checked, "_twr_=Radio_checked")>0 Then
			
				rbArr(irb).Click
			End If 
		Next 

'********************************************************************
'Case name: CME_EventLog_VerifyFieldVal
'Description: Verifies values in webedits in Event Log screens
'Created by : Subhash Patil
'Modified by and date: 02/06/2019
'********************************************************************* 	

Case "CME_EventLog_VerifyFieldVal"
	Keyword = True
	CME_TS_Executed=CME_TS_Executed+1
	BoolfieldExist=False
	On error resume next
	Arg=field
	propVal=CME_Value_from_Repository(Arg,"Value")
	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
	Set objDesc = Description.Create 'Creating description for the object
	For iProp = 0 To UBound(propValArr) 
	arr = split(propValArr(iProp),":=")  
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If				
	Next
	objDesc("visible").Value=true 'Adding Visible property to collection of description	
	
	Set textField = CME_application.Frame("html tag:=IFRAME","title:=Credit Management Enterprise").WebElement(objDesc).Webedit("visible:=true")
	
	If textField.Exist(20) Then
		strFieldval = textField.GetROProperty("value")
		If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(value)))>0 Then
            ReportPassed(i)
			'CME_resPassed='CME_resPassed+1                 
        else
        	scrnShotTitle="Value_Not_Found"
        	Call CaptureFailedObject(CME_application, textField, scrnShotTitle)
            CME_VerifyFieldValReportFailed(i)
            CME_resFailed=CME_resFailed+1
            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
        End If
	Else 
		scrnShotTitle="TxtField_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	End If
	Set textField=nothing	
	Set objDesc=Nothing

Case "CME_WriteInGlobalFile"
		Keyword = True
	    'CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		'Dim FSO, oExcel, oData, FoundCell, WHAT_TO_FIND, File_Path

		File_Path = "\\nterprise.net\Bankdata\QA\CME_Automation\Global\"& win_title_field &"\"& field &".xls"
		notFoundFields = 0
		strNotFound = ""
		Set oExcel = CreateObject("Excel.Application")
		oExcel.Visible = False
		oExcel.Workbooks.Open File_Path
		Set activeWSh = oExcel.ActiveWorkbook.Worksheets("CME")
		
'		value = Split(value, "|")
'		dataCount = UBound(value)
'		For iDC = 0 To dataCount
'			WHAT_TO_FIND = value(iDC)
'			Set FoundCell = activeWSh.Range(WHAT_TO_FIND)
'			If Not FoundCell Is Nothing Then
'			  dynamicVal=CME_FetchValueFromGlobalVariable(WHAT_TO_FIND)
'			  s
'				activeWSh.Range(WHAT_TO_FIND) = dynamicVal
'			  
'			Else
'				notFoundFields = notFoundFields + 1
'				strNotFound = strNotFound & "," & WHAT_TO_FIND
'			  	Reporter.ReportEvent micFail, WHAT_TO_FIND, " Field Not Found in Global File"
'			  	
'			  
'			  print (WHAT_TO_FIND & " not found")
'			End If
'		Next
		EnvVarsFile = "C:\Users\"& Environment.Value("UserName") & "\Documents\" & CME_Get_TC_Title & "_GlobalVariables.txt"
		Set fso=CreateObject("Scripting.FileSystemObject")
	
		set txtFileToRead=fso.OpenTextFile(EnvVarsFile, 1)
		Do Until txtFileToRead.AtEndOfStream
			Textline = txtFileToRead.Readline()
			If Trim(Textline) <> "" Then
				
				Textline = Split(Textline, "=")
				WHAT_TO_FIND = Textline(0)
				Set FoundCell = activeWSh.Range(WHAT_TO_FIND)
				If Not FoundCell Is Nothing Then
				  activeWSh.Range(WHAT_TO_FIND) = Trim(Textline(1)) 'writing fetched value to global file
				  
				Else
					notFoundFields = notFoundFields + 1
					strNotFound = strNotFound & "," & WHAT_TO_FIND
				  	print (WHAT_TO_FIND & " not found")
				End If
			End If
		
		Loop ' Read through every line
		
		
'		If notFoundFields > 0 Then
'			field = strNotFound
'			CME_ReportFailed(i)
'		End If
'		
		oExcel.ActiveWorkbook.Save
		oExcel.ActiveWorkbook.Close
		oExcel.Quit
		
		Set FoundCell = nothing 
		Set activeWSh = Nothing
		Set oExcel = Nothing
				
	
'********************************************************************
'Case name: CME_WriteInDataControlFile
'Description: To write values in DataControlFile
'Created by : Vaishnavi V
'Modified by and date: 3/18/21
'********************************************************************* 		
'DCF

Case "CME_WriteInDataControlFile"
		Keyword = True
	    'CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		'Dim FSO, oExcel, oData, FoundCell, WHAT_TO_FIND, File_Path
		
		File_Path = "\\nterprise.net\Bankdata\QA\CME_Automation\Datafiles\"& win_title_field &"\"& field &"\"& value &".xls"
		notFoundFields = 0
		strNotFound = ""
		Set oExcel = CreateObject("Excel.Application")
		oExcel.Visible = False
		oExcel.Workbooks.Open File_Path
		Set activeWSh = oExcel.ActiveWorkbook.Worksheets("DataControlFile")
		
'		value = Split(value, "|")
'		dataCount = UBound(value)
'		For iDC = 0 To dataCount
'			WHAT_TO_FIND = value(iDC)
'			Set FoundCell = activeWSh.Range(WHAT_TO_FIND)
'			If Not FoundCell Is Nothing Then
'			  dynamicVal=CME_FetchValueFromGlobalVariable(WHAT_TO_FIND)
'			  s
'				activeWSh.Range(WHAT_TO_FIND) = dynamicVal
'			  
'			Else
'				notFoundFields = notFoundFields + 1
'				strNotFound = strNotFound & "," & WHAT_TO_FIND
'			  	Reporter.ReportEvent micFail, WHAT_TO_FIND, " Field Not Found in Global File"
'			  	
'			  
'			  print (WHAT_TO_FIND & " not found")
'			End If
'		Next
		EnvVarsFile = "C:\Users\"& Environment.Value("UserName") & "\Documents\" & CME_Get_TC_Title & "_GlobalVariables.txt"
		Set fso=CreateObject("Scripting.FileSystemObject")
	
		set txtFileToRead=fso.OpenTextFile(EnvVarsFile, 1)
		Do Until txtFileToRead.AtEndOfStream
			Textline = txtFileToRead.Readline()
			If Trim(Textline) <> "" Then
				
				Textline = Split(Textline, "=")
				WHAT_TO_FIND = Textline(0)
				Set FoundCell = activeWSh.Range(WHAT_TO_FIND)
				If Not FoundCell Is Nothing Then
				  activeWSh.Range(WHAT_TO_FIND) = Trim(Textline(1)) 'writing fetched value to global file
				  
				Else
					notFoundFields = notFoundFields + 1
					strNotFound = strNotFound & "," & WHAT_TO_FIND
				  	print (WHAT_TO_FIND & " not found")
				End If
			End If
		
		Loop ' Read through every line
		
		
'		If notFoundFields > 0 Then
'			field = strNotFound
'			CME_ReportFailed(i)
'		End If
'		
		oExcel.ActiveWorkbook.Save
		oExcel.ActiveWorkbook.Close
		oExcel.Quit
		
		Set FoundCell = nothing 
		Set activeWSh = Nothing
		Set oExcel = Nothing

'********************************************************************
'Case name: CME_CSA_PrepaymentOption_AccrualMethod
'Description: Matches Accrual Method and Prepayment Options fields in Facility Modification screen
'Created by : Automation Team
'Modified by and date: 
'*********************************************************************      
Case "CME_CSA_PrepaymentOption_AccrualMethod"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
    On error resume next		
	set LHS_AcrMthd = CME_application.WebElement("html tag:=DIV","class:=textField", "attribute/fieldName:=configField51771", "index:=0", "visible:=true").WebEdit("visible:=true")
	set RHS_AcrMthd = CME_application.WebElement("html tag:=DIV","class:=dropDownGridBox", "attribute/fieldName:=LN_ACCRUAL_BASIS_DESC_END", "index:=0").WebEdit("visible:=true")
	If LHS_AcrMthd.Exist(10) Then
		LHS_AcrMthd_Val = LHS_AcrMthd.GetROProperty("value")
		If RHS_AcrMthd.Exist(5) Then
			RHS_AcrMthd.Click
			RHS_AcrMthd.object.value = LHS_AcrMthd_Val
	    	RHS_AcrMthd.Click
		Else 
	    	scrnShotTitle="RHS_AcrMthdNotFound"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 
		End If
	Else 
		scrnShotTitle="LHS_AcrMthdNotFound"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		On error goto 0
		Call CME_ExitTest() 
	End If 
	
	
	set LHS_PrepmntOpt = CME_application.WebElement("html tag:=DIV","class:=textField", "attribute/fieldName:=configField53177", "index:=0", "visible:=true").WebEdit("visible:=true")
	set RHS_PrepmntOpt = CME_application.WebElement("html tag:=DIV","class:=dropDownGridBox", "attribute/fieldName:=INDEX_PRE_PMT_OPTION_DESC", "index:=0").WebEdit("visible:=true")
	If LHS_PrepmntOpt.Exist(10) Then
		LHS_PrepmntOpt_Val = LHS_PrepmntOpt.GetROProperty("value")
		If LHS_PrepmntOpt_Val = "Open Prepay" Then
			LHS_PrepmntOpt_Val = "OPO"
		ElseIf LHS_PrepmntOpt_Val = "Period Lockout" Then
			LHS_PrepmntOpt_Val = "PLO"
		ElseIf LHS_PrepmntOpt_Val = "Full Yield Maintenance" Then
			LHS_PrepmntOpt_Val = "FYM"
		Else 
			LHS_PrepmntOpt_Val = "OPO"
		End If
		
		If RHS_PrepmntOpt.Exist(5) Then
	'		RHS_PrepmntOpt.Click
	'		RHS_AcrMthd.object.value = LHS_PrepmntOpt_Val
	'    	RHS_AcrMthd.Click
			RHS_PrepmntOpt.Set LHS_PrepmntOpt_Val
		Else 
	    	scrnShotTitle="RHS_PrepmntOpt"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 
		End If
	Else 
		scrnShotTitle="LHS_PrepmntOpt"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		On error goto 0
		Call CME_ExitTest() 
	End If 

		


 '********************************************************************
'Case name: CME_ClkImage
'Description: To click images
'Created by : Automation Team
'Modified by and date: 
'*********************************************************************      
       Case "CME_ClkImage"
      		Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume next
		    Arg=field
		    propVal=CME_Value_from_Repository(Arg,"Value")
		    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=") 
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If 
			Next
			objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		    
		    If Win_Title_Field="" Then
		    	Set img=CME_application.Image(objDesc)
		   	ElseIf UCase(Trim(Win_Title_Field))="WEBELEMENT" Then
			    
			    Set img=CME_application.WebElement(objDesc)
			End If
		    If img.Exist(10)=True Then
		    	img.Click
		    	'CME_resPassed='CME_resPassed+1
		    
		    Else
		    	scrnShotTitle="Image_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			
			Set img=nothing
			Set objDesc = Nothing
 
 '********************************************************************
'Case name: CME_GetDealNum
'Description: For getting deal number from deal tree
'Created by : Subhash Patil
'Modified by and date: 
'********************************************************************* 
      	Case "CME_GetDealNum"		
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    Environment.Value("DEALNUMBER") = CME_GetDealNum
		    'CME_resPassed='CME_resPassed+1


'********************************************************************
'Case name: CME_ClkLink
'Description: To click link
'Created by : Evry Automation Team  
'Modified by and date: Subhash Patil
'*********************************************************************  
      	Case "CME_ClkLink"      
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
	    'set objLink=CME_application.Frame("html tag:=IFRAME","title:=.*").link("innertext:="&field)
		set objLink=CME_application.link("html tag:=A","innertext:="&field,"visible:=true").Click	    
	    If objLink.Exist(10)=True Then
		   	objLink.Click
		    'CME_resPassed='CME_resPassed+1
		    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		else
			scrnShotTitle="Link_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 
		End If



'********************************************************************
'Case name: CME_Wait
'Description: To handle sync issues
'Created by : Evry Automation Team  
'Modified by and date:Muzaffar A 
'*********************************************************************
		Case "CME_Wait"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    If field<>"" Then 
	    	Wait field
	    Else 
	    	Wait 5
	    End If
	    'CME_resPassed='CME_resPassed+1
	    
'********************************************************************
'Case name: CME_CloseLatestOpenedBrowser
'Description: To close recently opened browsers
'Created by : Divya V C  
'Modified by and date:
'*********************************************************************	    
	    Case "CME_CloseLatestOpenedBrowser"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    CME_CloseLatestOpenedBrowser
	    'CME_resPassed='CME_resPassed+1

'********************************************************************
'Case name: CME_Refresh
'Description: To refresh page
'Created by : Evry Automation Team  
'Modified by and date:
'*********************************************************************
	    Case "CME_Refresh"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    Browser("micclass:=Browser").Refresh
	    CME_application.Sync
	    wait 3
	    'CME_resPassed='CME_resPassed+1


'********************************************************************
'Case name: CME_RecScen_MultipleEnts
'Description: 
'Created by :
'Modified by and date:
'*********************************************************************
	    Case "CME_RecScen_MultipleEnts"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    set activeScrn = CME_application.WebElement("html tag:=A", "innertext:=Entity Information.*", "index:=0")
		Set popUp = CME_application.Image("class:=image","file name:=\?_twr_=info\.png", "visible:=True","index:=0")
		Do while activeScrn.Exist(1)
			CME_application.WebElement("html tag:=A", "innertext:=Continue", "index:=0").Click
			Call CME_DynamicWait()
			
			Do While popUp.Exist(1)
				CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click
				Call CME_DynamicWait()
			Loop 
'			If popUp.Exist(3) Then
'				infoMsg = popUp.GetROProperty("innertext")
'			
'				If Instr(LCase(infoMsg), "would you like to pull credit report") > 0 Then
'					CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click
'				ElseIf Instr(LCase(infoMsg), "Would you like to Pull AgFast Score") > 0 Then
'					CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click 	
'				Else
'					Exit Do
'				End If
'			End If
'			Call CME_DynamicWait()
			
		Loop		       
		
		Do While popUp.Exist(1)
			CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click
			Call CME_DynamicWait()
		Loop 
		
		Set popUp = Nothing
		set activeScrn = Nothing
	
		
'********************************************************************
'Case name: CME_ECMUpload_Browse
'Description: For entering path in browse frame
'Created by : Evry Automation Team  
'Modified by and date:Muzaffar A
'*********************************************************************	    
	    Case "CME_ECMUpload_Browse"     
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    BoolfieldExist=CME_application.WebFile("name:=file").Exist(5)
		If Trim(Ucase(field)) = "NETWORK" Then
			value = "\\nterprise.net\Bankdata\QA\CME_Automation\DOCS\" & value
		End If
		Set ofs = CreateObject("Scripting.FileSystemObject")
		If ofs.FileExists(value) Then

		    If BoolfieldExist=True Then
			    CME_application.WebFile("name:=file").set value 
			    'CME_resPassed='CME_resPassed+1
			    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			
			Else 
				scrnShotTitle="DialogBox_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				On error goto 0
				Call CME_ExitTest() 
			End If
		Else 
			scrnShotTitle="Document_Not_Found"
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 		
		End If
'********************************************************************
'Case name: CME_CatchException
'Description: For Catching system exception
'Created by : Pavan Kumar 
'Modified by and date:
'*********************************************************************	 
		
	case "CME_CatchException"
	Keyword = True
	Call CME_CatchException()	
	
	
	Case  "CME_Optimist"
	Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call CME_Optimist()
	    
	    Case "Optimist_LaunchApplication"
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call Optimist_LaunchApplication()
	    
	    
'********************************************************************
'Case name: CME_VerifynumericField
'Description: Verifying field accepts only numeric value
'Created by : Pavan Kumar 
'Modified by and date:
'*********************************************************************	
	    
		Case "CME_VerifynumericField" 
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg)
		Set fieldval=CME_application.WebElement("attribute/fieldName:=" & propVal,"index:=0").WebEdit("visible:=true")
		
		BoolfieldExist=fieldval.Exist(10)
		If BoolfieldExist=true Then
			fieldval.Set value
			fieldeditable=fieldval.GetROProperty("readonly")
			fieldtype=fieldval.GetROProperty("type")
			If fieldtype="text" and isnumeric(value) and fieldeditable = 0 Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
				
			Else
				scrnShotTitle="NumericValue_Not_Found"
				Call CaptureFailedObject(CME_application,fieldval,scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				Reporter.ReportHtmlEvent micFail,field,"Non Numeric value entered"&"( Step.No" & i+1 & " )"
				Exit for
			End If
		
		Else
			scrnShotTitle="Field_Not_Found"
			Call CaptureScreen(scrnShotTitle)
	   		CME_ReportFailed(i)
	   		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	   		CME_resFailed=CME_resFailed+1
			
		End If
		Set fieldval=nothing

'********************************************************************
'Case name: CME_VerifyDDListContent
'Description: Verifies Drop down list content with expected from OR.
'Created by : Muzaffar A.
'Modified by and date: 04/17/2019
'field = Object's logical name
'********************************************************************* 	
	Case "CME_VerifyDDListContent"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, ",") 'Splitting property values fetched from OR
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
	
	Set listContent=CME_application.WebElement("class:=gridBox","attribute/fieldName:=","visible:=true").WebElement("class:=gridBoxContent","index:=0","visible:=true")
	''	listContent.Highlight
		If listContent.Exist(20)=True Then
	
			Set items=listContent.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rowcount=items.Count'Getting the rowcount of the grid
			BoolFlag=0
			For iList = 0 To rowcount-1
				item=Trim(items(iList).GetRoProperty("innertext"))
				item=Replace(item,",", "")	
				If Trim(item)=Trim(propValArr(iList)) Then
					BoolFlag=BoolFlag+1
				Else 
					msg=item&"NotMatchedWith"&propValArr(iList)
				End If 
			Next
			If BoolFlag=Ubound(propValArr)+1 Then 'Checking if all compared items matched with expected values
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle=msg
	        	Call CaptureFailedObject(CME_application, listContent, scrnShotTitle)
	            CME_VerifyFieldValReportFailed(i)
	            CME_resFailed=CME_resFailed+1
	            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			Set WshShell = CreateObject("WScript.Shell")
			WshShell.SendKeys "{TAB}" 'Unexpanding the drop down list
			Set WshShell=Nothing
		Else 
			scrnShotTitle="DropDownList_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
	   		CME_ReportFailed(i)
	   		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	   		CME_resFailed=CME_resFailed+1
		End If		
		
		Set items=Nothing
		Set listContent=Nothing
		Set gridcell=Nothing
		

'********************************************************************
'Case name: CME_Apply_Existing_Covenants_To_Deal
'Description: 
'Created by : Muzaffar A.
'Modified by and date: 

'********************************************************************* 	
Case "CME_Apply_Existing_Covenants_To_Deal"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("innertext").Value="N"
		'gridcell("innerhtml").Value=".*gbChecked.png.*"
		gridcell("visible").Value=true
		Set listContent=CME_application.WebElement("class:=gridBox","attribute/fieldName:=gbCovs","visible:=true").WebElement("class:=gridBoxColumn","visible:=true","index:=0")
		'listContent.Highlight
		Set items=listContent.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rowcount=items.Count'Getting the rowcount of the grid
		
		For iList = 0 To rowcount-1
			If items(iList).GetROProperty("innertext") = "N" Then
				items(iList).Click
			End If
		Next
		
		If items(rowcount-1).GetROProperty("innertext") = "Y" Then
			rdyFlg = True
		Else 
			rdyFlg = False
		End If

		For iflg = 0 To 10
			If rdyFlg Then
				Exit For
			Else 
				wait 2
			End If
		Next
			
		
		Set items=Nothing
		Set listContent=Nothing
		Set gridcell=Nothing



'********************************************************************
'Case name: CME_VerifyGridboxItem
'Description: Verifies GridBox item in core CME screens. Like Fees gridbox in Fees screen, dashboard gridbox, DDT gridbox, Related entities list gridbox and etc
'Created by : Muzaffar A.
'Modified by and date: 01/17/2019
'Win_Title_Field = Object's logical name
'field = rownumber||Column name
'value = expected value to compare
'********************************************************************* 		
	Case "CME_VerifyGridboxItem"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
	    Arg=Win_Title_Field
		propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
	    
	    fieldArr=split(field,"||")
	    rownum=fieldArr(0) 'fetching row number field
	    colName=Trim(Ucase(fieldArr(1))) 'fetching column name from field
		set gridBox=CME_application.WebElement(objDesc)
		If gridBox.Exist(20) Then
			'Description for column header name
			Set colheader=description.Create
			colheader("micClass").Value="WebElement"
			colheader("class").Value="gridBoxColumnHeader"
			
			'Getting the count of columns in the gridbox
			Set obj1=gridBox.Childobjects(colheader)
			columnCount=obj1.count
			
			'Getting the column names along with their position number in the grid to dictionary object
			Set dict = CreateObject("Scripting.Dictionary")
			For icol = 0 To columnCount-1
				dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
			Next
			
			'We specify column name in field and fetch it's position number in the grid from the dictionary object
			colNum=Trim(dict.Item(colName))
						
			'We use column number as an index gridBoxColumn object below
			indx=colNum-1
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
			Set obj2=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rowcount=obj2.Count 'Getting the rowcount of the grid
			If UCase(Trim(rownum))="LASTROW" Then 'Condition for lastrow item. When we have dynamic grid and need to click on the last row item.
				rownum=rowcount
			End If
			cellVal=obj2(rownum-1).getRoProperty("innertext")	
			field = Replace(field, "||", "_")			
			If Trim(Ucase(value))="NUMERICVALUE" Then 'For verifying dynamic numeric data
				If IsNumeric(trim(cellVal))=True Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="Value_Not_Numeric"
		        	If rownum > 0 Then
						Call CaptureFailedObject(CME_application, obj2(rownum-1), scrnShotTitle)
					Else 
						Call CaptureScreen(scrnShotTitle)
					End If
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			ElseIf Trim(Ucase(value))="NOTEMPTY" Then
				If Trim(cellval) <> "" Then
					ReportPassed(i)
				Else 
					scrnShotTitle="Cell_Empty"
					If rownum > 0 Then
						Call CaptureFailedObject(CME_application, obj2(rownum-1), scrnShotTitle)
					Else 
						Call CaptureScreen(scrnShotTitle)
					End If
		        	
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
				End If
			ElseIf Instr(Trim(Ucase(value)), "DYNAMIC|") > 0 Then
				value = Split(value, "|")
				valFromGlobalVar = CME_FetchValueFromGlobalVariable(value(1)) 'Fetching global variable 
				If Trim(Ucase(cellVal)) = Trim(Ucase(valFromGlobalVar)) Then
					ReportPassed(i)
				Else 
					scrnShotTitle="Value_Not_Matched"
		        	If rownum > 0 Then
						Call CaptureFailedObject(CME_application, obj2(rownum-1), scrnShotTitle)
					Else 
						Call CaptureScreen(scrnShotTitle)
					End If
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			
			Else 
				If ucase(trim(cellVal))=ucase(trim(value)) OR Instr(ucase(trim(cellVal)), ucase(trim(value)))>0 Then
		            ReportPassed(i)
					'CME_resPassed='CME_resPassed+1                 
		        else
		        	scrnShotTitle="Value_Not_Matched"
		        	If rownum > 0 Then
						Call CaptureFailedObject(CME_application, obj2(rownum-1), scrnShotTitle)
					Else 
						Call CaptureScreen(scrnShotTitle)
					End If
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		        End If
			End If
			
		Else 
			scrnShotTitle="Grid_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		
		End If
		
		Set obj2=Nothing
		Set gridBoxColumn=Nothing
		Set gridcell=Nothing
		Set dict = Nothing
		Set obj1=Nothing
		Set colheader=Nothing
		set gridBox=Nothing	



'********************************************************************
'Case name: CME_ClkGridboxItem
'Description: Clicks on GridBox item in core CME screens. Like Fees gridbox in Fees screen, dashboard gridbox, DDT gridbox, Related entities list gridbox and etc
'Created by : Muzaffar A.
'Modified by and date: 01/17/2019
'Win_Title_Field = Object's logical name
'field = rownumber||Column name
'value = expected value to compare
'********************************************************************* 		
	Case "CME_ClkGridboxItem"       
    	Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
	    Arg=Win_Title_Field
		propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
	    
	    fieldArr=split(field,"||")
	    rownum=fieldArr(0) 'fetching row number field
	    colName=Trim(Ucase(fieldArr(1))) 'fetching column name from field
		set gridBox=CME_application.WebElement(objDesc)
		If gridBox.Exist(20) Then
			'Description for column header name
			Set colheader=description.Create
			colheader("micClass").Value="WebElement"
			colheader("class").Value="gridBoxColumnHeader"
			
			'Getting the count of columns in the gridbox
			Set obj1=gridBox.Childobjects(colheader)
			columnCount=obj1.count
			
			'Getting the column names along with their position number in the grid to dictionary object
			Set dict = CreateObject("Scripting.Dictionary")
			For icol = 0 To columnCount-1
				dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
			Next
			
			'We specify column name in field and fetch it's position number in the grid from the dictionary object
			colNum=Trim(dict.Item(colName))
						
			'We use column number as an index gridBoxColumn object below
			indx=colNum-1
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
			Set obj2=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rowcount=obj2.Count 'Getting the rowcount of the grid
			If UCase(Trim(rownum))="LASTROW" Then 'Condition for lastrow item. When we have dynamic grid and need to click on the last row item.
				rownum=rowcount
			End If
			cellVal=obj2(rownum-1).getRoProperty("innertext")		
			If ucase(trim(cellVal))=ucase(trim(value)) Then
	            obj2(rownum-1).click
	            ReportPassed(i)
				'CME_resPassed='CME_resPassed+1                 
	        ElseIf value="" Then
	       		obj2(rownum-1).click
	            ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
	       	Else
	        	scrnShotTitle="Value_Not_Found"
	        	Call CaptureFailedObject(CME_application, obj2(rownum-1), scrnShotTitle)
	            CME_VerifyFieldValReportFailed(i)
	            CME_resFailed=CME_resFailed+1
	            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	        End If
		Else 
			scrnShotTitle=Win_Title_Field&"_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		
		End If

	Set obj2=Nothing
	Set gridBoxColumn=Nothing
	Set gridcell=Nothing
	Set dict = Nothing
	Set obj1=Nothing
	Set colheader=Nothing
	set gridBox=Nothing
	
		


'********************************************************************
'Case name: CME_VerifyObject
'Description: Verifies the objects like textfields, drop down lists, radio buttons and etc. exist in the screen or not using their logical names from OR.
'			  value column is used if for negative verification. (Ex: Verifying Birth Date field not present in the screen for Company Entity)
'value=NOT PRESENT when verifying object doesn't exist in the screen
'Created by : Muzaffar A.
'Modified by and date: 02/05/2019
'********************************************************************* 

	Case "CME_VerifyObject"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set obj=CME_application.WebElement(objDesc)
		If value="" Then
			If obj.Exist(10) Then
				ReportPassed(i)
	    		'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle="Object_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				
			End If
			
		ElseIf UCase(Trim(value))="NOT PRESENT" Then
			If obj.Exist(5)=False Then
				ReportPassed(i)
	    		'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle="Object_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				
			End If
		ElseIf UCase(Trim(value))="EDITABLE_TEXTFIELD" Then 'Verifies if the object is editable textfield
			Set txtField=obj.WebEdit("visible:=true")
			If txtField.Exist(10) Then
				If txtField.Object.isContentEditable=True Then
				ReportPassed(i)
	    		'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="NotEditable"
		        	Call CaptureFailedObject(CME_application, obj, scrnShotTitle)
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
			Else 
				scrnShotTitle="Object_NOT_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			
		ElseIf UCase(Trim(value))="DISABLED_RADIOBUTTON" Then
			disabled=obj.GetRoProperty("innerhtml")
			If Instr(disabled, "checkedDisabled")>0 Then
				ReportPassed(i)
	    		'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle="RadioButton_NOT_Disabled"
	        	Call CaptureFailedObject(CME_application, obj, scrnShotTitle)
	            CME_VerifyFieldValReportFailed(i)
	            CME_resFailed=CME_resFailed+1
	            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		End If
		Set obj=Nothing



'********************************************************************
'Case name: CME_EnterDynamicVal	
'Description: Enters dynamic values (current date, deal alias) in webedits
'Created by : Pavan kumar
'Modified by and date: Divya V C on 08/12/2019
'********************************************************************* 		
	Case  "CME_EnterDynamicVal"		
		   	Keyword = True
	   	 	CME_TS_Executed=CME_TS_Executed+1
	    	BoolfieldExist=False
	    	On error resume next
	    	If Trim(Win_Title_Field)<>"" Then
	    		If UCase(Trim(Win_Title_Field))="DEALALIAS" Then
	    		'intdealval=CME_application.WebElement("html tag:=SPAN","innertext:=.* - Status: .*","index:=1").GetROProperty("innertext")
	    		intdealval=CME_application.WebElement("class:=label", "html tag:=DIV","innertext:=Application.*","index:=0").GetROProperty("innertext") ' Fetching Application Number 
			    intstrlen=len(intdealval)
			    For j = 1 To intstrlen
			    	strdealval=Mid(intdealval,j,1)
			        If IsNumeric(strdealval) Then
			            intdealnum=intdealnum+strdealval
			        End If
		   		Next
		   		dynamicVal=intdealnum
		   		'Environment.Value("DEALALIAS")=dynamicVal
		   		call CME_FetchValueToGlobalVariable("DEALALIAS", dynamicVal)
		   		
			   	ElseIf UCase(Trim(Win_Title_Field))="CURRENTDATE" Then
			   		dynamicVal=date
		   
		    	End If
	    	Else 'When not mentioned we can give the name dynamically in value
	    		dynamicVal=CME_FetchValueFromGlobalVariable(value)
	    	End If 
		    
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
    		Set textField=CME_application.WebElement(objDesc).WebEdit("visible:=true") ' Modified by Muzaffar A. 
			BoolfieldExist=textField.Exist(30)
		If BoolfieldExist=true Then
			textField.Click
			textField.Set dynamicVal
			ReportPassed(i)
    		'CME_resPassed='CME_resPassed+1
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 
	   End If
			    
	   Set textField=nothing
	   

'********************************************************************
'Case name: CME_GetDynamicVal
'Description: Fetches Loan ID, Facility ID, Deal Alias, Deal Number and assigns it to Environment variable. Loan ID = last 4 digits of Facility Number
'Created by : Muzaffar A. 12/06/2018
'Modified by and date: Muzaffar A. 02/08/2019
'Note: User needs to navigate to target screen before using this keyword
'*********************************************************************	

	Case "CME_GetDynamicVal"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	
	  	'If Trim(Win_Title_Field)="" Then 'if Win_Title_Field empty it will only fetch value from textfields
	  		Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
	  		Set txtFld=CME_application.WebElement(objDesc).WebEdit("visible:=true")
		  	If txtFld.Exist(20) Then
		  		
		  		Setting.WebPackage("ReplayType")=2
					txtFld.FireEvent "onmouseover"
				Setting.WebPackage("ReplayType")=1
				
		  		dynVal=txtFld.GetROProperty("value")
				call CME_FetchValueToGlobalVariable(value, dynVal)
				Call CaptureScreen("")
		    	CME_ReportScreenshot(i)
			Else 
				scrnShotTitle="TextField_NotFound"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1			
			End If
			Set txtFld=Nothing
				
'	  	ElseIf UCase(Trim(Win_Title_Field))="DEALNUMBER" Then 'Fetches the deal number from the top left corner panel above deal tree
'			Set resizePanel=CME_application.WebElement("html tag:=IMG","attribute/fieldName:=Resize Panel Button","visible:=true")
'			If resizePanel.Exist(10) Then
'				Set objDealNum=resizePanel.Object.PreviousSibling
'				Arr=split(objDealNum.innertext, "Deal #")
'				dealNum=Arr(1)
'				'Assigning deal number to global variable
'				call CME_FetchValueToGlobalVariable("DEALNUMBER", dealNum)
'			Else 
'				scrnShotTitle="Object_NotFound"
'				Call CaptureScreen(scrnShotTitle)
'				CME_ReportFailed(i)
'				CME_resFailed=CME_resFailed+1
'				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			End If
'							
'			Set resizePanel=Nothing
'			Set objDealNum=Nothing				
'			
'		End If
	
  	

'********************************************************************
'Case name: CME_AngJS_GetDynamicVal	
'Description: Fetches dynamic values during runtime
'Created by : 
'Modified by and date:
'********************************************************************* 	
	Case  "CME_AngJS_GetDynamicVal"	
			Keyword = True
			CME_TS_Executed=CME_TS_Executed+1
			BoolfieldExist=False
			On error resume next
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description
			
			If UCase((Trim(Win_Title_Field)))="TEXTFIELD" Then
				Set textField = CME_application.WebEdit(objDesc)
				
				If textField.Exist(20) Then
					dynVal = textField.GetROProperty("value")
					call CME_FetchValueToGlobalVariable(value, dynVal)
				Else
					scrnShotTitle="Object_NotFound"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1				
				End  If
			End If
			
			Set textField = Nothing
			Set objDesc = Nothing
			
			
	
			
'********************************************************************
'Case name: CME_AngJS_VerifyDynamicVal	
'Description: Verifies dynamic values
'Created by : Pavan kumar
'Modified by and date: 12/06/2018
'********************************************************************* 		
	Case  "CME_AngJS_VerifyDynamicVal"	
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		'Verifies Deal Alias in a table in Deal Booking screen
		If UCase((Trim(Win_Title_Field)))="DEALALIAS_DB_TABLE" Then
			Set JStable=CME_application.WebTable("html tag:=Table","index:=0","visible:=True")
			If JStable.Exist(20) Then
			
				columns=JStable.GetROProperty("column names")
				colArr=split(columns, ";")
				
				Set dict = CreateObject("Scripting.Dictionary")
				
				For cols = 0 To ubound(colArr)
				
					dict.Add colArr(cols), cols+1
				Next
				'Note: field = Column Name that we want to fetch data from
				colName=Trim(dict.Item(field))
				'cellObj is used for Capturing the failed object
				Set cellObj=JStable.ChildItem(2, colName, "WebElement", 0)
				CellData = JStable.GetCellData(2,colName)
				aliasVal=Environment.Value("alias")
				If Trim(UCase(CellData))=Trim(UCase(aliasVal)) Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="alias_Not_Found"
					Call CaptureFailedObject(CME_application,cellObj,scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
				
			Else 
				scrnShotTitle="Table_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
			End If
		
		'Verifies if the innertext value of AngJS element matches with the environment variable
		ElseIf UCase(Trim(Win_Title_Field))="ANGJS_ELEMENT" Then
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
	  		
			Set El = CME_application.WebElement(objDesc)
			If El.Exist(5) Then
				ElVal=El.GetROProperty("innertext")
				expectedVal=Environment.Value(value) ' value holds the name of the environment variable
				If ucase(trim(ElVal))=ucase(trim(expectedVal)) Then
			        ReportPassed(i)
					'CME_resPassed='CME_resPassed+1                 
			    else
			    	scrnShotTitle="Value_Not_Found"
			    	Call CaptureFailedObject(CME_application, El, scrnShotTitle)
			        CME_VerifyFieldValReportFailed(i)
			        CME_resFailed=CME_resFailed+1
			        'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			
			'Verifying Deal/Facility ID in the Deal Booking grid box
		ElseIf UCase(Trim(Win_Title_Field))="FACILITYID_DB_TABLE" Then
			Set JStable=CME_application.WebTable("html tag:=Table","index:=0","visible:=True")
			If JStable.Exist(20) Then
			
				columns=JStable.GetROProperty("column names")
				colArr=split(columns, ";")
				
				Set dict = CreateObject("Scripting.Dictionary")
				
				For cols = 0 To ubound(colArr)
				
					dict.Add colArr(cols), cols+1
				Next
				'Note: field = Column Name that we want to fetch data from
				colName=Trim(dict.Item(field))
				'cellObj is used for Capturing the failed object
				Set cellObj=JStable.ChildItem(3, colName, "WebElement", 0)
				CellData = JStable.GetCellData(3,colName)
				facilIDVal="0"
				facilIDVal=facilIDVal & Trim(Environment.Value("facil_id"))
				
				If Trim(UCase(CellData))=Trim(UCase(facilIDVal)) Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="facilID_Not_Matched"
					Call CaptureFailedObject(CME_application,cellObj,scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
				
			Else 
				scrnShotTitle="Table_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
			End If
			
			'Facility Name in Deal Booking Screen. (Name = LoanID + Facility Type)
		ElseIf UCase(Trim(Win_Title_Field))="DB_FACILITYNAME" Then
			Set facilNameObj=CME_application.WebElement("html tag:=p","attribute/fieldName:=TxtField_Name_Facility","visible:=True")
			Set header=CME_application.WebElement("class:=standard-header","html tag:=H4","attribute/fieldName:=Facility_ID","visible:=True")
			If facilNameObj.Exist(20) Then
				headerVal=header.GetROProperty("innertext")
				objArr=split(headerVal, "Facility-")
				headerVal=objArr(1)
				facilName=facilNameObj.GetROProperty("innertext")
				If Trim(UCase(headerVal))=Trim(UCase(facilName)) Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="facilID_Not_Matched"
					Call CaptureFailedObject(CME_application,cellObj,scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 
		Else 
				scrnShotTitle="FacilNameObject_NOT_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
		End If
			
	
		End If
			

			    
    Set textField=nothing
    Set cellObj=nothing
	Set dict=nothing
	Set objDesc = Nothing
	Set JStable=nothing
	   
'********************************************************************
'Case name: CME_AngJS_SelectFromList
'Description: Selects from drop down list in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/21/2018
'********************************************************************* 	
	Case "CME_AngJS_SelectFromList"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		If Win_Title_Field="" Then
			Arg=field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description
					
			Set ddButton = CME_application.WebElement(objDesc)'WebButton(objDesc)
		Else 'When drop down doesn't have unique fieldName property we identify it with it's label
			Set ddButton=CME_application.WebElement("html tag:=SPAN","class:=input-group-addon","innertext:="&Win_Title_Field)
		End If
		
		If ddButton.Exist(20) Then
			'ddButton.FireEvent "onclick"
			ddButton.Click
			'wait 1
			
			If instr(value, "||")>0 Then 'If multiple selections from dropdown needed we can specify them in value with '||' delimeter
				item=split(value, "||") ' Splitting them by delimeter 
				For iDD = 0 To Ubound(item) 'looping through items to select from drop down list
					Set ddItem = CME_application.WebMenu("class:=dropdown-div dropdown-menu","role:=menu","visible:=true").WebElement("html tag:=TD","innertext:="& item(iDD),"index:=0","visible:=true")
					If ddItem.Exist(10) Then
						ddItem.Click
						'wait 1
						'CME_resPassed='CME_resPassed+1
						Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					Else 
						scrnShotTitle="Item_Not_Found"
						Call CaptureFailedObject(CME_application, ddButton, scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				Next
			Else 
				'When only one selection needed
				If Trim(ddButton.GetROProperty("innertext")) <> trim(value)  Then
					Set ddItem = CME_application.WebMenu("class:=dropdown-div dropdown-menu","role:=menu","visible:=true").WebElement("html tag:=TD","innertext:="& value,"index:=0","visible:=true")
					If ddItem.Exist(10) Then
						ddItem.Click
						'wait 1
						'CME_resPassed='CME_resPassed+1
						Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					Else 
						scrnShotTitle="Item_Not_Found"
						Call CaptureFailedObject(CME_application, ddButton, scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						
						On error goto 0
						Call CME_ExitTest()
						
					End If
				Else 
						ddButton.Click
						scrnShotTitle="Item_PreSelected"
						Call CaptureFailedObject(CME_application, ddButton, scrnShotTitle)
						CME_ReportWarning(i)
						'CME_resFailed=CME_resFailed+1
				End If
				
			End If
	Else 
		scrnShotTitle="DropDown_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	End If
		
		Set ddItem=Nothing
		Set ddButton=Nothing
		Set objDesc=Nothing

'********************************************************************
'Case name: CME_AngJS_EnterText
'Description: Enters text in webedits in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/21/2018
'********************************************************************* 	

	Case "CME_AngJS_EnterText"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		
		Set textField = CME_application.WebEdit(objDesc)
		If textField.Exist(20) Then
			textField.Set value
			'ReportPassed(i)
		    'CME_resPassed='CME_resPassed+1
		Else 
			scrnShotTitle="TxtField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set textField=nothing	
		Set objDesc=Nothing
		
'********************************************************************
'Case name: CME_AngJS_VerifyFieldVal
'Description: Verifies values in webedits in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/26/2018
'********************************************************************* 	
	
	Case "CME_AngJS_VerifyFieldVal"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		
		Set textField = CME_application.WebEdit(objDesc)
			
		If textField.Exist(20) Then
			strFieldval = textField.GetROProperty("value")
			If ucase(trim(value))="NOTEMPTY" Then
				If trim(strFieldval)<>"" Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="field_Empty"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			Else 
				If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(value)))>0 Then
		            ReportPassed(i)
					'CME_resPassed='CME_resPassed+1                 
		        else
		        	scrnShotTitle="Value_Not_Found"
		        	Call CaptureFailedObject(CME_application, textField, scrnShotTitle)
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		        End If
			End If
		Else 
			scrnShotTitle="TxtField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set textField=nothing	
		Set objDesc=Nothing
	
			
'********************************************************************
'Case name: CME_AngJS_VerifyDisabledFieldVal
'Description: Verifies values in disabled webedits in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 02/05/2019
'********************************************************************* 	
	
	Case "CME_AngJS_VerifyDisabledFieldVal"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
			
		Set textField = CME_application.WebEdit(objDesc)
	''	textField.Highlight
		If textField.Exist(20) Then
			strFieldval = textField.GetROProperty("value")
		''msgbox strFieldval
			If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(1, ucase(trim(strFieldval)), ucase(trim(value)))>0 Then
	            If textField.Object.IsDisabled=True Then
	            	ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
	            Else 
	            	scrnShotTitle="FieldNotDisabled"
		        	Call CaptureFailedObject(CME_application, textField, scrnShotTitle)
		            CME_VerifyFieldValReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	            End If
	                            
	        else
	        	scrnShotTitle="Value_Not_Found"
	        	Call CaptureFailedObject(CME_application, textField, scrnShotTitle)
	            CME_VerifyFieldValReportFailed(i)
	            CME_resFailed=CME_resFailed+1
	            'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	        End If
		Else 
			scrnShotTitle="TxtField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set textField=nothing	
		Set objDesc=Nothing
	
	
'********************************************************************
'Case name: CME_AngJS_ClkButton
'Description: Selects from drop down list in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/21/2018
'********************************************************************* 	
		Case "CME_AngJS_ClkButton"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		If trim(value)<>"" Then
			indx=value
		Else 
			indx=0
		End If
		
		Set btn = CME_application.WebButton("html tag:=BUTTON","class:=btn btn.*","innertext:="&field,"index:="&indx,"visible:=true")
		
		If btn.Exist(20) Then
			btn.Click
			'CME_resPassed='CME_resPassed+1
			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		Else 
			scrnShotTitle="Button_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set btn = Nothing
		
'********************************************************************
'Case name: CME_AngJS_CheckBox
'Description: checks the checkbox in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/26/2018
'********************************************************************* 	
	Case "CME_AngJS_CheckBox"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		set chkbx = CME_application.WebCheckBox(objDesc)
		'set chkbx = CME_application.WebCheckBox("html tag:=INPUT","type:=checkbox","attribute/fieldName:="& propVal,"visible:=True")
		If chkbx.Exist(20) Then	
			If Win_Title_Field="" Then
				If chkbx.GetROProperty("checked") <> 1 Then
					chkbx.Set "On"
				else
					scrnShotTitle="Item_PreSelected"
					Call CaptureFailedObject(CME_application, ddButton, scrnShotTitle)
					CME_ReportWarning(i)
				End If
				
				'CME_resPassed='CME_resPassed+1
				Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			Else 
				If UCase(Win_Title_Field)="VERIFY_CHECKED" Then
					If chkbx.GetROProperty("checked") = 1 Then
						ReportPassed(i)
					''	chkbx.Set "Off"
						'CME_resPassed='CME_resPassed+1
					Else 
						
						scrnShotTitle="Not_Checked"
			        	Call CaptureFailedObject(CME_application, chkbx, scrnShotTitle)
			            CME_ReportFailed(i)
			            CME_resFailed=CME_resFailed+1
						set chkbx = CME_application.WebCheckBox(objDesc)
						chkbx.Set "On"		            
					End If
				ElseIf UCase(Win_Title_Field)="VERIFY_UNCHECKED" Then
					If chkbx.GetROProperty("checked")=0 Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Checked"
			        	Call CaptureFailedObject(CME_application, chkbx, scrnShotTitle)
			            CME_ReportFailed(i)
			            CME_resFailed=CME_resFailed+1
			            'CME_FetchResultStatusAndEnterinFinalResults(resPath)					
					End If
				ElseIf UCase(Win_Title_Field)="VERIFY_DISABLED" Then
					If chkbx.Object.Isdisabled = True Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Disabled"
			        	Call CaptureFailedObject(CME_application, chkbx, scrnShotTitle)
			            CME_ReportFailed(i)
			            CME_resFailed=CME_resFailed+1
			            'CME_FetchResultStatusAndEnterinFinalResults(resPath)					
					End If
				Else 
					scrnShotTitle="Wrong_Win_Title_Field_Value"
		        	Call CaptureFailedObject(CME_application, chkbx, scrnShotTitle)
		            CME_ReportFailed(i)
		            CME_resFailed=CME_resFailed+1
		            'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
				End If
			End If	
		Else
			scrnShotTitle="CheckBox_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		set chkbx=Nothing
		Set objDesc = Nothing
		
		

'********************************************************************
'Case name: CME_AngJS_VerifyElement
'Description: Verifies Element exist or not in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/26/2018
'********************************************************************* 	
	Case "CME_AngJS_VerifyElement"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Set odesc=Description.Create
			odesc("html tag").Value="SPAN|DIV"
			odesc("class").Value="input-group-addon|custom-modal-header|font-data|tree-node tree-node-content angular-ui-tree-handle"
			odesc("innertext").Value=field
			odesc("visible").Value=True
		Set El=CME_application.WebElement(odesc)
		BoolfieldExist=El.Exist(10)
		If Trim(value)="" Then
			If BoolfieldExist=True Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle="Element_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		ElseIf UCase(Trim(value))="NOT PRESENT" Then 'for negative testing we use value column to specify 'NOT PRESENT'
			If BoolfieldExist=False Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else
				scrnShotTitle="Label_Found"
				Call CaptureFailedObject(CME_application, El, scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		End If
		
		Set El = Nothing
		Set odesc=Nothing
'********************************************************************
'Case name: CME_AngJS_VerifyElementVal
'Description: Verifies Element's value in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/26/2018
'********************************************************************* 		
	Case "CME_AngJS_VerifyElementVal"
		Keyword = True		
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
			
		Set El = CME_application.WebElement(objDesc)' Do NOT add FIELDSET tag in the collection
	
		If El.Exist(20) Then
			ElVal=El.GetROProperty("innertext")
			'Msgbox ElVal
			If Trim(UCase(win_title_field))<>"DYNAMIC" Then
				If value="" Then 'Adding condition for verifying when the field value is empty
                	If ElVal="" Then
                		ReportPassed(i)
			    		'CME_resPassed='CME_resPassed+1
	                    
					Else
						scrnShotTitle="Value_Not_Matched"
						Call CaptureFailedObject(CME_application, El, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
			
				ElseIf ucase(trim(value))="NUMERIC" Then 'When verifying populated value is numeric
					If IsNumeric(ElVal)=True Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Value_Not_Numeric"
						Call CaptureFailedObject(CME_application, El, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If
				ElseIf ucase(trim(value))="NOTEMPTY" Then 'When verifying field is not empty
					If trim(CellData)<>"" Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Field_Empty"&field
						Call CaptureFailedObject(CME_application, El, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If
				Else 
			    	If ucase(trim(value))=ucase(trim(ElVal)) OR instr(1, ucase(trim(ElVal)), ucase(trim(value)))>0 Then		
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
						
					Else
						scrnShotTitle="Value_Not_Found"
						Call CaptureFailedObject(CME_application, El, scrnShotTitle)
						CME_VerifyFieldValReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				End If
			Else 'Condition for when field value is dynamic. In this case we give environment variable in value column.
				valFromGlobalVar = CME_FetchValueFromGlobalVariable(value)
				If ucase(trim(valFromGlobalVar))=ucase(trim(ElVal)) OR instr(1, ucase(trim(ElVal)), ucase(trim(valFromGlobalVar)))>0 Then		
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
						
				Else
					scrnShotTitle="DynamicValue_Not_Found"
					Call CaptureFailedObject(CME_application, El, scrnShotTitle)
					CME_VerifyFieldValReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			End If
			
			
		Else 
			scrnShotTitle="Element_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set El=Nothing
		Set objDesc = Nothing
'********************************************************************
'Case name: CME_AngJS_ClickLabel
'Description: Clicks on labels (Basic Information, Legal Address and etc) and radio buttons in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/27/2018
'********************************************************************* 		
	
	Case "CME_AngJS_ClickLabel"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		If win_title_field="" Then
			Set label = CME_application.WebElement("html tag:=A|SPAN","class:=input-group-addon","innertext:="&field,"visible:=True","index:=0")
		Else 
			Set label = CME_application.WebElement("html tag:=A|SPAN","class:="&win_title_field,"innertext:="&field,"visible:=True","index:=0")
		End If
		
		If label.Exist(20) Then
			label.Click
			'CME_resPassed='CME_resPassed+1
			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			
		Else 
			scrnShotTitle="Label_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If		
		Set label = Nothing	



'********************************************************************
'Case name: CME_AngJS_ClickLink
'Description: Clicks on Links
'********************************************************************* 		
	
	Case "CME_AngJS_ClickLink"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume next
		
			Set label = CME_application.WebElement("html tag:=A|SPAN","Class Name:=Link","innertext:="&field,"visible:=True","index:=0")

		
		If label.Exist(20) Then
			label.Click
			'CME_resPassed='CME_resPassed+1
			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			
		Else 
			scrnShotTitle="Link_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If		
		Set label = Nothing	


'********************************************************************
'Case name: CME_AngJS_SectionHeader
'Description: Clicks/Verifies on Section Headers (Basic Information, Legal Address, Industry Classification and etc) 
'Created by : Muzaffar A.
'Modified by and date: 06/20/2019
'********************************************************************* 	
	Case "CME_AngJS_SectionHeader"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set sHdr = CME_application.WebElement(objDesc)
		
			If sHdr.Exist(20)=True Then
				If UCase(Trim(win_title_field))="CLICK" Then
					sHdr.Click
					'CME_resPassed='CME_resPassed+1
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				ElseIf UCase(Trim(win_title_field))="VERIFYSTATUS" Then
					statusClr=sHdr.WebElement("html tag:=SPAN","class:=cme-status-glyph glyphicon.*").Object.style.color
					'status=tab.WebElement("html tag:=SPAN","class:=cme-status-glyph glyphicon.*").GetROProperty("attribute/uib-tooltip")
					If statusClr="rgb(0, 221, 0)" Then
						tabStatus="COMPLETE"
					ElseIf statusClr="rgb(255, 102, 0)" Then
						tabStatus="INCOMPLETE"
					End If
					If tabStatus=UCase(Trim(value)) Then
						ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
					Else 
						scrnShotTitle="Status_NOT_Matched"
						Call CaptureFailedObject(CME_application, sHdr, scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
					End If
				End If
			Else 
				scrnShotTitle="SectionHeader_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		
		
		Set sHdr = Nothing
		

'********************************************************************
'Case name: CME_AngJS_Tab
'Description: Verifies Status/Clicks on Tabs (Profiles/Locations,Remit Instructions,Servicing Groups and etc) 
'Created by : Muzaffar A.
'Modified by and date: 06/20/2019
'********************************************************************* 	
	Case "CME_AngJS_Tab"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
	    Arg=field
	    propVal=CME_Value_from_Repository(Arg,"Value")
	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set tab = CME_application.Link(objDesc)
		
			If tab.Exist(20)=True Then
				If UCase(Trim(win_title_field))="CLICK" Then
					tab.Click
					'CME_resPassed='CME_resPassed+1
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				ElseIf UCase(Trim(win_title_field))="VERIFYSTATUS" Then
					statusClr=tab.WebElement("html tag:=SPAN","class:=cme-status-glyph glyphicon.*").Object.style.color 'Getting style color
					'status=tab.WebElement("html tag:=SPAN","class:=cme-status-glyph glyphicon.*").GetROProperty("attribute/uib-tooltip")
					If statusClr="rgb(0, 221, 0)" Then 'If color is green then status is Complete
						tabStatus="COMPLETE"
					ElseIf statusClr="rgb(255, 102, 0)" Then 'If color is red then status is Incomplete
						tabStatus="INCOMPLETE"
					Else
						scrnShotTitle="Tab_Error"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						On error goto 0
						Call CME_ExitTest() 
					End If
					If tabStatus=UCase(Trim(value)) Then
						scrnShotTitle = ""
					    Call CaptureScreen(scrnShotTitle)
					    CME_ReportScreenshot(i)
					Else 
						scrnShotTitle="Status_NOT_Matched"
						Call CaptureFailedObject(CME_application, tab, scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						On error goto 0
						Call CME_ExitTest() 
					End If
				End If
			Else 
				scrnShotTitle="SectionHeader_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
			Set tab = Nothing




'********************************************************************
'Case name: CME_AngJS_VerifyTableContent
'Description: Verifies table cell data in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 11/29/2018
'Win_Title_Field= Table's Logical Name from OR || Row description. (Either cell text or row number)
'field=Column Name
'value=expected value to compare
'********************************************************************* 		
Case "CME_AngJS_VerifyTableContent"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
		'In Win_Title_Field we specify table name and row separated by '||'	    
		Win_Title_Field=split(Win_Title_Field,"||")
		tableName=Trim(Win_Title_Field(0))
		rowDesc=Trim(Win_Title_Field(1))
		Arg=tableName
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		
		Set JStable=CME_application.WebElement(objDesc).WebTable("html tag:=Table","visible:=True")
		'Set JStable=CME_application.WebElement("html tag:=st-grid-box","attribute/fieldname:=LIQ_Deals_PostDocs_Grid").WebTable("html tag:=Table","visible:=True")
		If JStable.Exist(20) Then
			If IsNumeric(rowDesc)=False Then
				rowNumber=JStable.GetRowWithCellText(rowDesc)
			Else 
				rowNumber=rowDesc
			End If
			
			columns=JStable.GetROProperty("column names")
			columns=replace(columns, "'","")
			colArr=split(columns, ";")
			
			Set dict = CreateObject("Scripting.Dictionary")
			
			For cols = 0 To ubound(colArr)
			
				dict.Add colArr(cols), cols+1
			Next
				
			colName=Trim(dict.Item(field))
			'cellObj is used for Capturing the failed object
			Set cellObj=JStable.ChildItem(rowNumber, colName, "WebElement", 0)
			
			CellData = JStable.GetCellData(rowNumber,colName)
			If CellData="" Then
				Set cellObj=JStable.ChildItem(rowNumber, colName, "WebEdit", 0)
				CellData=cellObj.GetROProperty("value")
			End If
			If ucase(trim(value))="NUMERICVALUE" Then
				If IsNumeric(CellData)=True Then
					'ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
					scrnShotTitle="NUMERICVALUE_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportScreenshot(i)
				Else 
					scrnShotTitle="Value_Not_Numeric"&tableName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			ElseIf ucase(trim(InStr(value,"DYNAMICVALUE||")))>0 Then
				dynamArr=split(value, "||")
				dynVal=dynamArr(1)
				
				If dynVal<>"" Then
					valFromGlobalVar = CME_FetchValueFromGlobalVariable(value)
					If ucase(trim(valFromGlobalVar))=ucase(trim(CellData)) OR instr(1, ucase(trim(CellData)), ucase(trim(valFromGlobalVar)))>0 Then		
						'ReportPassed(i)
						'CME_resPassed='CME_resPassed+1
						scrnShotTitle="DynamicValue_Found"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportScreenshot(i)
					Else
						scrnShotTitle="DynamicValue_Not_Found"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						'CME_FetchResultStatusAndEnterinFinalResults(resPath)
					End If
				Else  
					
				End If
				
			ElseIf ucase(trim(value))="NOTEMPTY" Then
				If trim(CellData)<>"" Then
					ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
				Else 
					scrnShotTitle="Cell_Empty"&tableName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
				End If
			Else
				If Trim(UCase(CellData))=Trim(UCase(value)) OR instr(1, ucase(trim(CellData)), ucase(trim(value)))>0 Then
					'ReportPassed(i)
					'CME_resPassed='CME_resPassed+1
					'ElseIf True Then
					scrnShotTitle="Value_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportScreenshot(i)
				Else 
					scrnShotTitle="Value_Not_Found_in_"&tableName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					If Instr(LCase(CellData), "error") > 0 OR Instr(LCase(CellData), "failed") > 0 Then
						On error goto 0
						Call CME_ExitTest() 
					End If
					'Contacts tab Preferred Language defaulting issue workaround
					If tableName = "EntityBoarding_ContactsSummaryTable" Then
						If CME_application.WebElement("attribute/fieldName:=PreferredLanguage_btn", "html tag:=BUTTON", "index:=0").GetROProperty("innertext") = "" Then
							Call AngJS_Click_Btn("Update Contacts", 0)
						End If 
					End If
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If 			
				
			End If
			
			
		Else 
			scrnShotTitle="Table_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
		End If
	
		Set cellObj=nothing
		Set dict=nothing
		Set JStable=nothing
		Set objDesc = Nothing
		
		
	Case "CME_AngJS_FetchTableContent"       
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume Next
		'In field we specify table name, row and column name separated by '||'	 
		Tablecontent=field	
		Arrtablecontent=split(Tablecontent,"||")
		tableName=Trim(Arrtablecontent(0))
		rowDesc=Trim(Arrtablecontent(1))
	''	Colnum=Trim(Win_Title_Field(2))
		Arg=tableName
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		
		Set JStable=CME_application.WebElement(objDesc).WebTable("html tag:=Table","visible:=True")
		'Set JStable=CME_application.WebElement("html tag:=st-grid-box","attribute/fieldname:=LIQ_Deals_PostDocs_Grid").WebTable("html tag:=Table","visible:=True")
		If JStable.Exist(20) Then
			If IsNumeric(rowDesc)=False Then
				rowNumber=JStable.GetRowWithCellText(rowDesc)
			Else 
				rowNumber=rowDesc
			End If
			
			columns=JStable.GetROProperty("column names")
			columns=replace(columns, "'","")
			colArr=split(columns, ";")
			
			Set dict = CreateObject("Scripting.Dictionary")
			
			For cols = 0 To ubound(colArr)
			
				dict.Add colArr(cols), cols+1
			Next
				
			colName=Trim(dict.Item(Arrtablecontent(2)))
			'cellObj is used for Capturing the failed object
			Set cellObj=JStable.ChildItem(rowNumber, colName, "WebElement", 0)
			
			CellData = JStable.GetCellData(rowNumber,colName)
		If CellData <> "" Then
			dynVal= CellData
		msgbox dynVal
			call CME_FetchValueToGlobalVariable(value, dynVal)
		Else
		    scrnShotTitle="Tablecelldata_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If
			

		Else 
			scrnShotTitle="Table_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
		Call CME_ExitTest() 
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
		End If
'	
		Set cellObj=nothing
		Set dict=nothing
		Set JStable=nothing
		Set objDesc = Nothing
'********************************************************************
'Case name: CME_AngJS_ClkTableContent
'Description: clicks table cell data in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 12/06/2018
'Win_Title_Field= Table's Logical Name from OR
'field=Column Name
'value=row number that we want to click
'********************************************************************* 		
	Case "CME_AngJS_ClkTableContent"       
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume Next
			Arg=Win_Title_Field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If				
			Next
			objDesc("visible").Value=true 'Adding Visible property to collection of description
			
			Set JStable=CME_application.WebElement(objDesc).WebTable("html tag:=Table","visible:=True")
			'Set JStable=CME_application.WebElement("html tag:=st-grid-box","attribute/fieldname:=LIQ_Deals_PostDocs_Grid").WebTable("html tag:=Table","visible:=True")
			If JStable.Exist(20) Then
				rowDesc=value
				If IsNumeric(rowDesc)=False Then
					rowNumber=JStable.GetRowWithCellText(rowDesc)
					If rowNumber < 0 Then
						JStable.Highlight
						scrnShotTitle=rowdesc &"_Not_Found"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						On error goto 0
						Call CME_ExitTest() 
					End If 
				Else 
					rowNumber=rowDesc
				End If
				columns=JStable.GetROProperty("column names")
				columns=replace(columns, "'","")
				colArr=split(columns, ";")
				
				Set dict = CreateObject("Scripting.Dictionary")
				
				For cols = 0 To ubound(colArr)
				
					dict.Add colArr(cols), cols+1
				Next
					
				colName=Trim(dict.Item(field))
				'cellObj is used for Capturing the failed object
				Set cellObj=JStable.ChildItem(rowNumber, colName, "WebElement", 0)
				
					cellObj.click					
					'CME_resPassed='CME_resPassed+1 
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
			Else 
				scrnShotTitle=Win_Title_Field &"_Table_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)	
			End If
		
			Set cellObj=nothing
			Set dict=nothing
			Set JStable=nothing
			Set objDesc=Nothing
			
			
'********************************************************************
'Case name: CME_FBL_CloseDeal
'Description: Closes the deal in Deal Booking
'Created by : Muzaffar A.
'Modified by and date: 10/19/2020
'Win_Title_Field= Table's Logical Name from OR
'field=Column Name
'value=row number that we want to click
'********************************************************************* 		
	Case "CME_FBL_CloseDeal"       
		    Keyword = True
		    CME_TS_Executed=CME_TS_Executed+1
		    BoolfieldExist=False
		    On error resume Next			
			'clicking on Close Deal button	
			Call AngJS_Click_Btn("Close Deal", 0)
			'Loading
			call CME_AngJS_LoadingWait()
			'Close Window displayed
			Set clsWndw = CME_application.WebElement("class:=modal-content","html tag:=DIV","innertext:= Close Deal    You are about to close.*", "visible:=True", "index:=0")
			If clsWndw.Exist(60) Then
				Set dateField = CME_application.WebEdit("html tag:=INPUT","name:=closeDate","visible:=True", "index:=0")
				If dateField.Exist(20) Then
					dateField.Set value
					wait 1
					Call AngJS_Click_Btn("Close Deal", 0)
					wait 1
					call CME_AngJS_LoadingWait()
				Else 
					scrnShotTitle="CloseDateField_NotFound"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest()
				End If
			Else 
				scrnShotTitle="CloseDealWindow_NotFound"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest()
			End If
			
			Set clsSts = CME_application.WebElement("class:=modal-content", "innertext:=Info:.*","visible:=True","index:=0")
			'clsSts.Highlight
			passFlg = True
			If clsSts.Exist(30) Then
				Do  while clsSts.Exist(2)
					clsMsg = clsSts.GetROProperty("innertext")
					If LCase(Trim(clsMsg)) = "info: deal personnel update success  ok" OR LCase(Trim(clsMsg)) = "info: deal successfully closed  ok" then
						Call AngJS_Click_Btn("OK", 0)
						Reporter.ReportHtmlEvent micPass,"Deal Personnel Update", "Success"
						call CME_AngJS_LoadingWait()
					ElseIf Instr(Lcase(clsMsg), "error: this loan officer does not have a loan officer job function") > 0  Then
						Call CaptureScreen(scrnShotTitle)
						reporter.ReportEvent micWarning, "Loan Officer", "Loan Officer does not have a Loan Officer job function"
						CME_ReportFailed(i)
					Else
						passFlg = False
						scrnShotTitle="DealClosing_Unsuccessful"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						On error goto 0
						Call CME_ExitTest()
					End If 
				Loop
			End If
			
			If passFlg = True Then
				Call CaptureScreen("CloseDealSuccess")
			    CME_ReportScreenshot(i)
			End If
			
			Call AngJS_Click_Btn("Close Window", 0)
			call CME_AngJS_LoadingWait()
			
			Set clsSts = Nothing
			Set clsWndw = Nothing
						
'********************************************************************
'Case name: CME_AngJS_VerifyPopUpMsg
'Description: Verifies info message in screens developed with AngularJS 
'Created by : Muzaffar A.
'Modified by and date: 12/06/2018
'********************************************************************* 
	Case "CME_AngJS_VerifyPopUpMsg"       
		Call CME_DynamicWait()
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume Next
		Set objPopup=CME_application.WebElement("class:=modal-content","html tag:=DIV","visible:=True", "index:=0")
		If objPopup.Exist(20) Then
			msg=objPopup.GetROProperty("innertext")
			If Trim(UCase(msg))=Trim(UCase(value)) OR instr(1, ucase(trim(msg)), ucase(trim(value)))>0 Then
				Call CaptureScreen("Success")
			    CME_ReportScreenshot(i)
			Else 
				
				scrnShotTitle="Value_Not_Found"
				Call CaptureFailedObject(CME_application,objPopup,scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				If Instr(LCase(msg), "error") > 0 OR Instr(LCase(msg), "failed") > 0 Then
					On error goto 0
					Call CME_ExitTest() 
				End If
			End If
		Else 
			scrnShotTitle="PopUp_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
	
'********************************************************************
'Case name: CME_AngJS_DragDropItem
'Description: Used for dragging and dropping item for Payment Rules Order in Deal Booking 
'Created by : Muzaffar A.
'Modified by and date: 12/10/2018
'********************************************************************* 
	Case "CME_AngJS_DragDropItem"       
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1
		BoolfieldExist=False
		On error resume Next
		Set icon=CME_application.WebElement("class:=glyphicon glyphicon-chevron-left","html tag:=SPAN","visible:=True")
		'Clicking on the icon to collapse the payment items
		If icon.Exist(20) Then
			icon.Click
			wait 3
		End If
		
		Set dragObj=CME_application.WebElement("html tag:=DIV","class:=tree-node tree-node-content angular-ui-tree-handle","innertext:="&field&"   ","visible:=True")
		Set dropObj=CME_application.WebElement("html tag:=DIV","class:=tree-node tree-node-content angular-ui-tree-handle","innertext:="&value&"   ","visible:=True")
		If dragObj.Exist(10) AND dropObj.Exist(10) Then
			dragObj.Drag
			dropObj.Drop
			wait 3
			'CME_resPassed='CME_resPassed+1
			Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"			
		Else 
			scrnShotTitle="Item_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		End If
		Set dropObj=Nothing
		Set dragObj=Nothing
		Set icon=Nothing		
		

'********************************************************************
'Case name: CME_VerifyDatabaseVal
'Description: Fetches data from database and verifies it against expected value
'Created by : Muzaffar A.
'Modified by and date: 12/26/2018
'value = expected value that we give in data file
'********************************************************************* 
  	Case "CME_VerifyDatabaseVal"
	  	Keyword=True
	  	BoolfieldExist=false
		CME_TS_Executed=CME_TS_Executed+1		
		dbVal=CME_DataFromDataBase ' Function that fetches record from database depending on query from action 2
			If Trim(Ucase(dbVal))=Trim(Ucase(value)) Then
				ReportPassed(i)
				'CME_resPassed='CME_resPassed+1
			Else 
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If

'********************************************************************
'Case name: CME_VerifyYBSFieldVal_Database
'Description: Fetches data from database and verifies it against YBS field Value
'Created by : Muzaffar A.
'Modified by and date: 12/26/2018
'value = logical name of the object
'********************************************************************* 
	Case "CME_VerifyYBSFieldVal_Database"
      	Keyword=True
      	BoolfieldExist=false
		CME_TS_Executed=CME_TS_Executed+1		
		dbVal=CME_DataFromDataBase ' Function that fetches record from database depending on query from action 2
		
		Arg=value
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding Visible property to collection of description
		
		Set ybsField=CME_application.WebEdit(objDesc)
			If ybsField.Exist(5) Then
				strFieldval=ybsField.GetROProperty("value")
				If instr(1, strFieldval, ".00")>0 Then      ''''Updated by Subhash patil
					arrArray = Split(strFieldval, ".")
					strFieldval =arrArray(0)
				End If
				
	            If ucase(trim(dbVal))=ucase(trim(strFieldval)) Then
	            	ReportPassed(i)
		    		'CME_resPassed='CME_resPassed+1
		    	Else 
		    		scrnShotTitle=value&"Value_Not_Found"
					Call CaptureFailedObject(CME_application, ybsField, scrnShotTitle)
		    		CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
				End If
			Else 
					scrnShotTitle=value&"_Not_Found"
					Call CaptureScreen(scrnShotTitle)
		    		CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			End If
		Set ybsField=nothing	
		Set objDesc = Nothing


'********************************************************************
'Case name: CME_GetApplicationNumber
'Description: Fetches Application number during runtime and assigns to a variable
'Created by : Muzaffar A.
'Modified by and date: 08/23/2019


'*********************************************************************
	Case "CME_GetApplicationNumber"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    Call CME_GetApplicationNumber()
	    
'********************************************************************
'Case name: CME_Search_AppNumber
'Description: searches for Application number during run time
'Created by : Muzaffar A.
'Modified by and date: 08/23/2019


'*********************************************************************	

	Case "CME_Search_AppNumber"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
	    Set srchField = CME_application.WebElement("class:=textField", "attribute/fieldName:=Go to Deal Number", "index:=0").WebEdit("visible:=True")
	    If srchField.Exist(10) Then
	    	srchField.Click
	    	srchField.Set environment.Value("CurrAppNum")
	    	set mySendKeys = CreateObject("WScript.shell")
			mySendKeys.SendKeys("{ENTER}")
	    	'ReportPassed(i)
		    'CME_resPassed='CME_resPassed+1
	    Else 
	    	scrnShotTitle="Searchbox_Not_Found"
			Call CaptureScreen(scrnShotTitle)
    		CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest()  
	    End If
		set mySendKeys = Nothing
		 Set srchField = Nothing
		 


'********************************************************************
'Case name: CME_LoadDealWithAppNumber
'Description: searches for Application number during run time
'Created by : Muzaffar A.
'Modified by and date: 09/23/2019


Case "CME_LoadDealWithAppNumber"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
	    Call CME_LoadingCircle()
	    On error resume next
	    If CME_application.WebElement("html tag:=A", "innertext:=Cancel", "index:=0", "visible:=True").Exist(1) Then
	    	CME_application.WebElement("html tag:=A", "innertext:=Cancel", "index:=0", "visible:=True").Click
	    	Call CME_LoadingCircle()
	    End If 
	    If value<>"" Then
	    	appNumForSrch = value
	    Else 
	    	appNumForSrch = Environment.Value("CurrAppNum")
	    End If
	    appNumForSrch = Environment.Value("CurrAppNum")
	    
	    Set dashbrd = CME_application.WebElement("class:=gridBox", "attribute/fieldName:=Dashboard GridBox", "index:=0", "visible:=True")
		If dashbrd.Exist(30) Then
			Set appNumCell = CME_application.WebElement("class:=gridBoxCell", "innertext:="& appNumForSrch, "index:=0")
			If appNumCell.Exist(1) Then
				appNumCell.Click
				Set okBtn = CME_application.WebElement("html tag:=A","innertext:=OK","visible:=True")
				If okBtn.Exist(5) = True Then
					okBtn.Highlight
					okBtn.Click
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				Else 
					appNumCell.DoubleClick
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
				End If
				
			Else 
				
				Set srchIcn = CME_application.Image("class:=image","file name:=\?_twr_=magsmall\.png","visible:=True")
				If srchIcn.Exist(10) Then
					srchIcn.Click
					Set srchWndw = CME_application.WebElement("class:=textField","attribute/fieldName:=APP Search","index:=0").WebEdit("name:=WebEdit","visible:=True")
					If srchWndw.Exist(10) Then
						srchWndw.Set appNumForSrch
						'srchWndw.Highlight
						srchWndw.Click
						wait 1
						Call CME_ClickButton("Go", "")
						
						If CME_application.WebElement("html tag:=DIV", "innertext:=MessageNo Deals.*","visible:=True").Exist(2) = True Then
							scrnShotTitle="Application_Number_Not_Found"
							Call CaptureScreen(scrnShotTitle)
							CME_ReportFailed(i)
							CME_resFailed=CME_resFailed+1
							On error goto 0
							Call CME_ExitTest()  
						
						End If
					Else 	
						scrnShotTitle="SearchWndw_Not_Found"
						Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						CME_resFailed=CME_resFailed+1
						On error goto 0
						Call CME_ExitTest()  
					End If
				Else 
					scrnShotTitle="SearchIcon_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest()  
				End If
				
				call CME_DynamicWait()
				
				If appNumCell.Exist(10) Then
					appNumCell.Click
					Set okBtn = CME_application.WebElement("html tag:=A","innertext:=OK","visible:=True")
					If okBtn.Exist(5) = True Then
						okBtn.Highlight
						okBtn.Click
						Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					Else 
						appNumCell.DoubleClick
						Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
					End If
					
				Else 
					scrnShotTitle="Application_Number_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest()  
				End If
				
				
			End If	
				
				
		Else 
			scrnShotTitle="Dashboard_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest()  
		
		End If		
				

	Set srchWndw = Nothing
	Set srchIcn = Nothing
	Set appNumCell = Nothing
	Set dashbrd = Nothing


'********************************************************************
'Case name: CME_CSi_VerifyDocuments
'Description: Verifies if the Documents (Pre-Closing,Closing) in Documents screen are generated/rendered/missing/not rendered
'Created by : Muzaffar A.
'Modified by and date: 05/02/2019
'Win_Title_Field= Pre-Closing/Closing    'we specify what documents in this column
'field=Use Case ID

'********************************************************************* 

Case "CME_CSi_VerifyDocuments"
	Keyword = True
	On error Resume Next
	CME_TS_Executed=CME_TS_Executed+1
	
	'****** Fetching borrower names ***********************
	'setting object for Borrowing Entities branch in deal tree
	Set BorrEnts = CME_application.Webelement("html tag:=DIV","class:=treeRow","innertext:=Borrowing Entities.*","index:=0","visible:=true")
	
	Set oDesc = description.Create
	oDesc("class").value="treeRow"
	oDesc("html tag").value="DIV"
	oDesc("innertext").value=".* Info.*"
	oDesc("visible").value=True
	'Fetching Borrower names from collection
	Set dict = CreateObject("Scripting.Dictionary")
	Set borrNames=BorrEnts.Childobjects(oDesc)
	For iDealTree = 0 To borrNames.count-1
		strName=Split(borrNames(iDealTree).GetRoProperty("innertext"), " Info")
		dict.Add "Borrower_"&iDealTree+1, strName(0)
	Next
	
	'**********************************************
	
	'***** Looping thru Documents in View Grid ********************
	
	set gridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=DocumentGrid","visible:=true")
	If gridBox.Exist(20) Then
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set colDocName=gridBox.WebElement("class:=gridBoxColumn","index:=1","visible:=true")	'Document Name column			
		Set colDocNameContent=colDocName.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rcDocName=colDocNameContent.Count 'Getting the rowcount of the Document Name column
					
		Set colRelTo=gridBox.WebElement("class:=gridBoxColumn","index:=3","visible:=true")	'Document Name column			
		Set colRelToContent=colRelTo.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rcRelTo=colRelToContent.Count 'Getting the rowcount of the Related To column
		If rcRelTo=rcDocName Then
			gridRowCount=rcDocName
		End If
		Set xlCSiDocs = createobject("Excel.Application")
			xlCSiDocs.visible=False
			xlCSiDocs.Workbooks.Open("H:\CME_Automation\TestData\"&field&".xlsx") 'Opening Expected CSi Documents excel file.
			Set wsh=xlCSiDocs.Worksheets(Win_Title_Field) ' identifying the sheet. Either Pre-Closing or Closing
			rowcount=wsh.UsedRange.Rows.Count
			colcount=wsh.UsedRange.Columns.Count
		generatedDocs=""
		renderedDocs=""
		NotRenderedDocs=""
		missingDoc=""
		xtraDoc=""
	
		'Fetching Document names and comparing them with expected 
		If gridRowCount<>0 Then
			For iDocs = 0 To gridRowCount-1 
				
				docName=Trim(colDocNameContent(iDocs).GetROProperty("innertext"))
				borrName=Trim(colRelToContent(iDocs).GetROProperty("innertext"))
				
				If Trim(borrName)<>"-" Then 'When Related To column is generated with Borrower names
					For iBorr = 1 To borrNames.count
						If Trim(UCase(borrName))=Trim(UCase(dict.Item("Borrower_"&iBorr))) Then
							borrName="Borrower "&iBorr
							combString=docName&"-"&borrName
							generatedDocs=generatedDocs& vbcrlf &iDocs+1&". "&combString 'Storing generated documents to string
							dict.Add combString, "Document_"&iDocs+1 'Adding Document Name to Dictionary object which will be used to identify unexpected docs later.
							'Looping thru expected document names in excel sheet to find a match
							For iXL = 2 To rowcount
								matchCount=0 'Count for identifying if Document names not matched with expected
								PreClsDocName=Trim(wsh.Cells(iXL,1).value)
								If UCase(Trim(combString))=UCase(Trim(PreClsDocName)) Then 'Checking for possible duplicate documents
									colDocNameContent(iDocs).Click 'Clicking on Documents Name to generate
									Set GenDocBtn = CME_application.WebElement("html tag:=A","attribute/fieldName:=Generate Documents")
									If GenDocBtn.Exist(10) Then
										GenDocBtn.Click
										wait 5
										'On error resume next
										'Handling CSI Pop up starts here
										Call CME_CSi_PopUP()
	'									 
										'End of handling CSi pop up 
										
										Set CSiDocLink=CME_application.link("html tag:=A","class:=hyperlink","innertext:=Click here to view .*"&docName&".*","visible:=true")    
										    If CSiDocLink.Exist(10)=True Then
											   	CSiDocLink.Click 'Clicking on hyperlink Document Name
											   	Wait 5
											   	Set pdfPage=Browser("creationtime:=1")
											   	pdfPage.Sync
												strTitle=pdfPage.GetROProperty("title")
												If pdfPage.Exist(10)=True and UCase(right(strTitle,4))=".PDF" OR UCase(right(strTitle,4))=".HTM" Then 'Verifying Document is opened in new tab
								    			
								    				CME_CSi_DocsFldr = "\\nterprise.net\Bankdata\QA\Automation-EVRY\CMEtoCSi\RESULTS\CSiDocsResults\"&respth(3)&"\RenderedDocs\"&Win_Title_Field
								    				set filesys=CreateObject("Scripting.FileSystemObject") 
													If Not filesys.FolderExists(CME_CSi_DocsFldr) Then 
														filesys.CreateFolder(CME_CSi_DocsFldr) 
													End If
													DealNum = "Deal_" & CME_GetDealNum() 'Fetching deal number from screen and assigning to variable
													dealNumFldr=CME_CSi_DocsFldr &"\"& DealNum
													
													If NOT filesys.FolderExists(dealNumFldr) Then
														filesys.CreateFolder(dealNumFldr) 
													End If
													
													docFilePath = dealNumFldr &"\"& combString & ".pdf" 'Assigning logical name to the document
													If filesys.FileExists(docFilePath) Then
														filesys.DeleteFile(docFilePath) 'Deleting if the same file exists
													End If
													set filesys=Nothing
													CME_SavePDFfromBrowser(docFilePath) 'Saving the document in a given filepath
													
								    				Call CME_CloseLatestOpenedBrowser()
													renderedDocs=renderedDocs & vbcrlf & iDocs+1&". "& combString
													Reporter.ReportHtmlEvent micPass,Win_Title_Field,"-"&combString&" Rendered"											
												Else 
													NotRenderedDocs=NotRenderedDocs & vbcrlf & iDocs+1&". "& combString
													Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&combString&" Not Rendered" 'Report if PDF page doesn't exist
												End If
												CME_application.WebElement("attribute/fieldName:=Done","html tag:=A","visible:=true").Click	'Clicking on Done button									
											Else 
												Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Link NOT Found"'Report if hyperlink doesn't exist
											End If
									Else 
										Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Generate Documents button NOT Found"'Report if Generate Documents button doesn't exist
									End If
									colDocNameContent(iDocs).Click
									matchCount=matchCount+1
									Exit for 'When expected is met exiting the inner loop
								
								End If
							Next
							If matchCount=0 Then 'If document was not found in expected list then report document name as failed
								xtraDoc=xtraDoc &vbcrlf& iDocs+1&". "& combString
								Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&combString&" Document NOT expected"
							End If
							Exit for 'Exiting the loop when borrower name matched with names from deal tree
						End If
						
					Next
				
				Else ''When Related To column is NOT generated with Borrower names
					'Looping thru expected document names in excel sheet to find a match
					dict.Add docName, "Document_"&iDocs+1 'Adding Document Names to Dictionary object which will be used to identify unexpected docs later.
					generatedDocs=generatedDocs& vbcrlf &iDocs+1&". "&docName 'Storing generated documents to string
					For iXL = 2 To rowcount
						matchCount=0
						PreClsDocName=Trim(wsh.Cells(iXL,1))
						If UCase(Trim(docName))=UCase(Trim(PreClsDocName)) Then
							colDocNameContent(iDocs).Click 'Clicking on Documents Name to generate
							Set GenDocBtn = CME_application.WebElement("html tag:=A","attribute/fieldName:=Generate Documents")
									If GenDocBtn.Exist(10) Then
										GenDocBtn.Click
										wait 5
										
		'								'Handling CSI Pop up starts here
										Call CME_CSi_PopUP()
										'End of handling CSi pop up 
										
										Set CSiDocLink=CME_application.link("html tag:=A","class:=hyperlink","innertext:=Click here to view .*"&docName&".*","visible:=true")    
										    If CSiDocLink.Exist(10)=True Then
											   	CSiDocLink.Click 'Clicking on hyperlink Document Name
											   	Wait 10
											   	Set pdfPage=Browser("creationtime:=1")
											   	pdfPage.Sync
												strTitle=pdfPage.GetROProperty("title")
												If pdfPage.Exist(10)=True and UCase(right(strTitle,4))=".PDF" OR UCase(right(strTitle,4))=".HTM"Then 'Verifying Document is opened in new tab
								    				CME_CSi_DocsFldr = "\\nterprise.net\Bankdata\QA\Automation-EVRY\CMEtoCSi\RESULTS\CSiDocsResults\"&respth(3)&"\RenderedDocs\"&Win_Title_Field
								    				set filesys=CreateObject("Scripting.FileSystemObject") 
													If Not filesys.FolderExists(CME_CSi_DocsFldr) Then 
														filesys.CreateFolder(CME_CSi_DocsFldr) 
													End If
													DealNum = "Deal_" & CME_GetDealNum()
													dealNumFldr=CME_CSi_DocsFldr &"\"& DealNum
													
													If NOT filesys.FolderExists(dealNumFldr) Then
														filesys.CreateFolder(dealNumFldr) 
													End If
													
													docFilePath = dealNumFldr &"\"& docName & ".pdf" 'Assigning logical name to the document
													If filesys.FileExists(docFilePath) Then
														filesys.DeleteFile(docFilePath) 'Deleting if the same file exists
													End If
													set filesys=Nothing
													CME_SavePDFfromBrowser(docFilePath) 'Saving the document in a given filepath
																																	    				
								    				Call CME_CloseLatestOpenedBrowser()
													renderedDocs=renderedDocs & vbcrlf & iDocs+1 &"."& docName
													Reporter.ReportHtmlEvent micPass,Win_Title_Field,"-"&docName&" Rendered"											
												Else 
													NotRenderedDocs=NotRenderedDocs & vbcrlf & iDocs+1 &"."&docName
													Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Not Rendered"'Report if PDF page doesn't exist
												End If
												CME_application.WebElement("attribute/fieldName:=Done","html tag:=A","visible:=true").Click	'Clicking on Done button									
											Else 
												Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Link NOT Found"
												CME_application.WebElement("attribute/fieldName:=Done","html tag:=A","visible:=true").Click 'Clicking on Done button
											End If
									Else 
										Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Generate Documents button NOT Found"'Report if Generate Documents button doesn't exist
									End If
							colDocNameContent(iDocs).Click
							matchCount=matchCount+1
							Exit for 'When expected is met exiting the inner loop
						
							
						
						End If
					Next	
					
					If matchCount=0 Then 'If document was not found in expected list then report document name as failed
						xtraDoc=xtraDoc &vbcrlf& iDocs+1 &"."& docName
						Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Document NOT expected"
					End If			
				End If	
			Next
		
		Else 'When Documents in View grid has no documents inside 
			For iMD = 2 To rowcount
				'matchCount=0 'Count for identifying if Document names not matched with expected
				missingDoc=missingDoc & vbcrlf & wsh.Cells(iMD,1).value
			Next
			renderedDocs="None"
			generatedDocs="None"
			NotRenderedDocs="Not Applicable"
		End If
	Else 'Reporting if the Grid not found
		Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-Documents in View grid NOT Found"
	End If
	'End of Looping thru the Document Selection Grid
	
	'Checking if all expected documents have been generated in the selection grid
	For iMD = 2 To rowcount
		PreClsDocName=Trim(wsh.Cells(iMD,1))
		If dict.Exists(PreClsDocName)=False Then 'checking if expected document name exists in list of documents displayed in the grid
			missingDoc=missingDoc & vbcrlf & PreClsDocName 'Report expected document name not found in the grid
		End If
	Next	
	
	'xlCSiDocs.ActiveWorkbook.Save
	xlCSiDocs.ActiveWorkbook.Close
	xlCSiDocs.Application.Quit
	Set xlCSiDocs=Nothing
	'Reporting Results to Result file
	Set xlCSiDocs = createobject("Excel.Application")
	xlCSiDocs.visible=False
	csiResSrcFile="V:\Automation-EVRY\CMEtoCSi\RESULTS\CSiDocsResults\"&respth(3)&"\CMEtoCSiAutomatedTestExecutionResults.xlsx" 'filepath for CSi documents results
	xlCSiDocs.Workbooks.Open(csiResSrcFile) 'Opening Expected CSi Documents sheet.
	Set resSheet=xlCSiDocs.Worksheets(1) ' identifying the sheet
	rowcount=resSheet.UsedRange.Rows.Count
	'colcount=resSheet.UsedRange.Columns.Count
	For iXL = 2 To rowcount
		useCaseID=resSheet.Cells(iXL,2).value
		If Trim(useCaseID)=field Then
			rowNum=iXL
			Exit for 
		End If
	Next
	
	
	resSheet.Cells(rowNum,1)=now() 'writing Time Stamp to CSi results sheet
	resSheet.Cells(rowNum,4)=CME_GetDealNum() 'writing Deal# to CSi results sheet
	
	If Trim(generatedDocs)="" Then
		generatedDocs="None"
	ElseIf Trim(renderedDocs)="" Then
		renderedDocs="None"
	ElseIf Trim(xtraDoc)="" Then
		xtraDoc="None"
	ElseIf Trim(NotRenderedDocs)="" Then
		NotRenderedDocs="None"
	ElseIf Trim(missingDoc)="" Then
		missingDoc="None"
	End If
	
'	scrnShotFolder="V:\Automation-EVRY\CMEtoCSi\RESULTS\ScreenShots\"&respth(3)
'	set filesys=CreateObject("Scripting.FileSystemObject") 
'	If Not filesys.FolderExists("V:\Automation-EVRY\CMEtoCSi\RESULTS\ScreenShots\"&respth(3)) Then 
'		scrnShotFolder = filesys.CreateFolder("V:\Automation-EVRY\CMEtoCSi\RESULTS\ScreenShots\"&respth(3)) 
'	End If
'	set filesys=Nothing	
	
	scrnShotURL=scrnShotFolder  & "\"& field &"_"& Win_Title_Field &"_DocsInView.png"
	
'	CME_application.CaptureBitmap scrnShotURL, True 'Taking the screen shot of the page	
	Desktop.CaptureBitmap scrnShotURL, True 'Taking the screen shot of the page	
	If Trim(UCase(Win_Title_Field))="PRE-CLOSING" Then
		For iClear = 5 To 10
			resSheet.Cells(rowNum,iClear).ClearContents 'Clearing old results for Pre-Closing until Closing Results Columns from result sheet 
		Next
		resSheet.Cells(rowNum,5)=generatedDocs'Generated Documents Column
		resSheet.Cells(rowNum,6)=missingDoc 'Missing Documents Column
		resSheet.Cells(rowNum,7)=renderedDocs 'Render Documents Column
		resSheet.Cells(rowNum,8)=NotRenderedDocs 'Not Rendered Documents Column
		resSheet.Cells(rowNum,9)=xtraDoc 'Unexpected Documents Column
		resSheet.Cells(rowNum,10)="=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
		resSheet.Cells.WrapText=true
		resSheet.Range("E"&rowNum&":I"&rowNum).Copy 'Copying the results from CSi Results sheet
		Call CME_ReportCSi(Win_Title_Field) 'Pasting the CSi results to Test Result Sheet
	
	ElseIf Trim(UCase(Win_Title_Field))="CLOSING" Then
		For iClear = 11 To 16
			resSheet.Cells(rowNum,iClear).ClearContents 'Clearing old results for Closing until Screenshots Columns from result sheet 
		Next
		resSheet.Cells(rowNum,11)=generatedDocs'Generated Documents Column
		resSheet.Cells(rowNum,12)=missingDoc 'Missing Documents Column
		resSheet.Cells(rowNum,13)=renderedDocs 'Render Documents Column
		resSheet.Cells(rowNum,14)=NotRenderedDocs 'Not Rendered Documents Column
		resSheet.Cells(rowNum,15)=xtraDoc 'Unexpected Documents Column
		resSheet.Cells(rowNum,16)="=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
		resSheet.Cells.WrapText=true
		resSheet.Activate
		resSheet.Range("K"&rowNum&":O"&rowNum).Copy 'Copying the results from CSi Results sheet
		Call CME_ReportCSi(Win_Title_Field) 'Pasting the CSi results to Test Result Sheet
	End If
	
	xlCSiDocs.ActiveWorkbook.Save
	xlCSiDocs.ActiveWorkbook.Close
	xlCSiDocs.Application.Quit
	
	Set objRange = Nothing
	Set xlCSiDocs = Nothing
	Set pdfPage = Nothing
	Set CSiDocLink = Nothing
	Set GenDocBtn = Nothing
	Set wsh = Nothing
	Set colRelToContent = Nothing
	Set colRelTo = Nothing
	Set colDocNameContent = Nothing
	Set colDocName = Nothing
	Set gridcell = Nothing
	set gridBox = Nothing
	Set borrNames = Nothing
	Set dict = Nothing
	Set oDesc = Nothing
	Set BorrEnts = Nothing
'*********************** Copying the the most recent result sheet to H: Drive(Local) folder ***********************
'	Set CSifso = CreateObject("Scripting.FileSystemObject")
'	
'	If CSifso.FileExists(csiResSrcFile) Then
'		 CsiDestinationFile = "H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\CMEtoCSiAutomatedTestExecutionResults.xlsx"
'		 CSiBckUpFile = "V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\CMEtoCSiAutomatedTestExecutionResults.xlsx"
'		 CSiSourceFile = csiResSrcFile
'		
'		If Not CSifso.FolderExists("H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)) Then
'			CsiDestinationFldr = CSifso.CreateFolder ("H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3))
'		End If
'	    Check to see if the file already exists in the destination folder
'	    If CSifso.FileExists(CsiDestinationFile) Then
'	        Check to see if the file is read-only
'	        If Not CSifso.GetFile(CsiDestinationFile).Attributes And 1 Then 
'	            The file exists and is not read-only.  Safe to replace the file.
'	            CSifso.CopyFile CSiSourceFile, "H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	        Else 
'	            The file exists and is read-only.
'	            Remove the read-only attribute
'	            CSifso.GetFile(CsiDestinationFile).Attributes = CSifso.GetFile(CsiDestinationFile).Attributes - 1
'	            Replace the file
'	            CSifso.CopyFile CSiSourceFile, "H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	            Re-apply the read-only attribute
'	            CSifso.GetFile(CsiDestinationFile).Attributes = CSifso.GetFile(CsiDestinationFile).Attributes + 1
'	        End If
'	    Else
'	        The file does not exist in the destination folder.  Safe to copy file to this folder.
'	        CSifso.CopyFile CSiSourceFile, "H:\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	    End If
'
'*************** Saving the result sheet in backup location in network ***************************
'		If Not CSifso.FolderExists("V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)) Then
'			CsiBckUpFldr = CSifso.CreateFolder ("V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3))
'		End If
'	    Check to see if the file already exists in the backup folder
'	    If CSifso.FileExists(CSiBckUpFile) Then
'	        Check to see if the file is read-only
'	        If Not CSifso.GetFile(CSiBckUpFile).Attributes And 1 Then 
'	            The file exists and is not read-only.  Safe to replace the file.
'	            CSifso.CopyFile CSiSourceFile, "V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	        Else 
'	            The file exists and is read-only.
'	            Remove the read-only attribute
'	            CSifso.GetFile(CSiBckUpFile).Attributes = CSifso.GetFile(CSiBckUpFile).Attributes - 1
'	            Replace the file
'	            CSifso.CopyFile CSiSourceFile, "V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	            Re-apply the read-only attribute
'	            CSifso.GetFile(CSiBckUpFile).Attributes = CSifso.GetFile(CSiBckUpFile).Attributes + 1
'	        End If
'	    Else
'	        The file does not exist in the backup folder.  Safe to copy file to this folder.
'	        CSifso.CopyFile CSiSourceFile, "V:\Automation-EVRY\Updated_FBL\CME_Automation\RESULTS\CSiDocsResults\"&respth(3)&"\", True
'	    End If
'	Set CSifso = Nothing
'	End If
	

'********************************************************************
'Case name: CME_Verify_CSI_Documents
'Description: Verifies if the Documents (Pre-Closing,Closing) in Documents screen are generated/rendered/missing/not rendered
'Created by : Muzaffar A.
'Modified by and date: 05/02/2019
'Win_Title_Field= Pre-Closing/Closing    'we specify what documents in this column
'field=Use Case ID

'********************************************************************* 	
	
	Case "CME_Verify_CSI_Documents"
	Keyword = True
	On error Resume Next
	CME_TS_Executed=CME_TS_Executed+1
	
	'****** Fetching borrower names ***********************
	'setting object for Borrowing Entities branch in deal tree
	Set BorrEnts = CME_application.Webelement("html tag:=DIV","class:=treeRow","innertext:=Borrowing Entities.*","index:=0","visible:=true")
	
	Set oDesc = description.Create
	oDesc("class").value="treeRow"
	oDesc("html tag").value="DIV"
	oDesc("innertext").value=".* Info.*"
	oDesc("visible").value=True
	'Fetching Borrower names from collection
	Set dict = CreateObject("Scripting.Dictionary")
	Set borrNames=BorrEnts.Childobjects(oDesc)
	For iDealTree = 0 To borrNames.count-1
		strName=Split(borrNames(iDealTree).GetRoProperty("innertext"), " Info")
		dict.Add "Borrower_"&iDealTree+1, strName(0)
	Next
	
	'**********************************************
	
	'***** Looping thru Documents in View Grid ********************
	
	set gridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=DocumentGrid","visible:=true")
	If gridBox.Exist(20) Then
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set colDocName=gridBox.WebElement("class:=gridBoxColumn","index:=1","visible:=true")	'Document Name column			
		Set colDocNameContent=colDocName.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rcDocName=colDocNameContent.Count 'Getting the rowcount of the Document Name column
					
		Set colRelTo=gridBox.WebElement("class:=gridBoxColumn","index:=3","visible:=true")	'Related To column			
		Set colRelToContent=colRelTo.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rcRelTo=colRelToContent.Count 'Getting the rowcount of the Related To column
		If rcRelTo=rcDocName Then
			gridRowCount=rcDocName
		End If
		
'		If Suite="CME_Automation" Then
'			testDataPath = "\\nterprise.net\Bankdata\QA\CME_Automation\TestData\"
'		ElseIf Suite="End_to_End_Automation_Scripts" Then    
'			testDataPath = "\\nterprise.net\Bankdata\QA\End_to_End_Automation_Scripts\CME-FBL\TestData\"
'		End If
		
		Set xlCSiDocs = createobject("Excel.Application")
		xlCSiDocs.visible=False
		xlCSiDocs.Workbooks.Open(Path) 'Opening Expected CSi Documents excel file.
		'xlCSiDocs.Workbooks.Open(testDataPath & field &".xlsx") 'Opening Expected CSi Documents excel file.
		Set wsh=xlCSiDocs.Worksheets(Win_Title_Field) ' identifying the sheet. Either Pre-Closing or Closing
		rowcount=wsh.UsedRange.Rows.Count
		colcount=wsh.UsedRange.Columns.Count
		generatedDocs=""
		renderedDocs=""
		NotRenderedDocs=""
		missingDoc=""
		xtraDoc=""
	
		'Fetching Document names and comparing them with expected 
		If gridRowCount<>0 Then
			For iDocs = 0 To gridRowCount-1 
				
				docName=Trim(colDocNameContent(iDocs).GetROProperty("innertext"))
				borrName=Trim(colRelToContent(iDocs).GetROProperty("innertext"))
				
				If Trim(borrName)<>"-" Then 'When Related To column is generated with Borrower names
					For iBorr = 1 To borrNames.count
						If Trim(UCase(borrName))=Trim(UCase(dict.Item("Borrower_"&iBorr))) Then
							borrName="Borrower "&iBorr
							combString=docName&"-"&borrName
							generatedDocs=generatedDocs& vbcrlf &iDocs+1&". "&combString 'Storing generated documents to string
							dict.Add combString, "Document_"&iDocs+1 'Adding Document Name to Dictionary object which will be used to identify unexpected docs later.
							'Looping thru expected document names in excel sheet to find a match
							For iXL = 2 To rowcount
								matchCount=0 'Count for identifying if Document names not matched with expected
								PreClsDocName=Trim(wsh.Cells(iXL,1).value)
								If UCase(Trim(combString))=UCase(Trim(PreClsDocName)) Then 'Checking for possible duplicate documents
									colDocNameContent(iDocs).Click 'Clicking on Documents Name to generate
									matchCount=matchCount+1
									Exit for 'When expected is met exiting the inner loop
								End If
							Next
							If matchCount=0 Then 'If document was not found in expected list then report document name as failed
								xtraDoc=xtraDoc &vbcrlf& iDocs+1&". "& combString
								Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&combString&" Document NOT expected"
							End If
							Exit for 'Exiting the loop when borrower name matched with names from deal tree
						End If
					Next
				Else ''When Related To column is NOT generated with Borrower names
					'Looping thru expected document names in excel sheet to find a match
					dict.Add docName, "Document_"&iDocs+1 'Adding Document Names to Dictionary object which will be used to identify unexpected docs later.
					generatedDocs=generatedDocs& vbcrlf &iDocs+1&". "&docName 'Storing generated documents to string
					For iXL = 2 To rowcount
						matchCount=0
						PreClsDocName=Trim(wsh.Cells(iXL,1))
						If UCase(Trim(docName))=UCase(Trim(PreClsDocName)) Then
							colDocNameContent(iDocs).Click 'Clicking on Documents Name to generate
							matchCount=matchCount+1
							Exit for 'When expected is met exiting the inner loop
						End If
					Next	
					
					If matchCount=0 Then 'If document was not found in expected list then report document name as failed
						xtraDoc=xtraDoc &vbcrlf& iDocs+1 &"."& docName
						Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"&docName&" Document NOT expected"
					End If			
				End If	
			Next
			
		Else 'When Documents in View grid has no documents inside 
			For iMD = 2 To rowcount
				'matchCount=0 'Count for identifying if Document names not matched with expected
				missingDoc=missingDoc & vbcrlf & wsh.Cells(iMD,1).value
			Next
			renderedDocs="None"
			generatedDocs="None"
			NotRenderedDocs="Not Applicable"
		End If
'		Next
	Else 'Reporting if the Grid not found
		Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-Documents in View grid NOT Found"
	End If
	'End of Looping thru the Document Selection Grid
	
	'Checking if all expected documents have been generated in the selection grid
	For iMD = 2 To rowcount
		PreClsDocName=Trim(wsh.Cells(iMD,1))
		If dict.Exists(PreClsDocName)=False Then 'checking if expected document name exists in list of documents displayed in the grid
			missingDoc=missingDoc & vbcrlf & PreClsDocName 'Report expected document name not found in the grid
		End If
	Next	
	
	
	xlCSiDocs.ActiveWorkbook.Save
	xlCSiDocs.ActiveWorkbook.Close
	xlCSiDocs.Application.Quit
	Set xlCSiDocs=Nothing
			
			
	
										 
		
	
	If Trim(generatedDocs)="" Then
		generatedDocs="None"
	End If
	
	If Trim(xtraDoc)="" Then
		xtraDoc="None"
	End If
	
	If Trim(missingDoc)="" Then
		missingDoc="None"
	End If
	

	Randomize 
	rndNum = Cint((10000*RND))
	timeStmp = Replace(date, "/", "")
	scrnShotURL=scrnShotFolder & "\" & field &"_"& Win_Title_Field &"_"& timeStmp & rndNum &"_DocsInView.png"

	'CME_application.CaptureBitmap scrnShotURL, True 'Taking the screen shot of the page	
	Desktop.CaptureBitmap scrnShotURL, True 
	'******************* Reporting to CME to CSi results file starts here ********************************
	Const xlCenter = -4108
	Const xlLeft = -4131
	Const xlTop = -4160
	
	

strTC_CSi_title=CME_Get_TC_Title & "_CME-CSi_Results"
set filesys=CreateObject("Scripting.FileSystemObject") 

	csiResFile = CME_CSiFolder & "\" & strTC_CSi_title & ".xlsx"
	If Not filesys.FileExists(csiResFile) Then ' if file doesn't exist then create a new file
		If Not filesys.FolderExists(CME_CSiFolder) Then ' if folder doesn't exist then create a new folder
			filesys.CreateFolder(CME_CSiFolder)
			csiResFile = CME_CSiFolder & "\" & strTC_CSi_title & ".xlsx"
		End If 	
		Set csiXL = CreateObject ("Excel.Application")
		csiXL.Visible = False
		Set objWorkBook = csiXL.Workbooks.Add
		Set closSh = csiXL.ActiveWorkbook.Worksheets(1)
		closSh.Name = "Closing"
		Set preclosSh=csiXL.ActiveWorkbook.Worksheets.Add
		preclosSh.Name = "Pre-Closing"
		Set activeWSh = csiXL.ActiveWorkbook.Worksheets(Win_Title_Field)
		
		With activeWSh
				'Adding column headers to CSi results sheets
			    .Range("A1:F1") = Array("Execution Time", "Deal #", "Documents Appeared in Selection Logic", "Missing Expected Documents", "Unexpected Documents", "Screenshot")
			    .Range("A1:F1").Font.Bold = True
			    .Range("A1:F1").Interior.ColorIndex="40"
			    .Range("C1:F1").ColumnWidth="40"
			    .Range("A1:F1").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the left
			    '.Range("A2:F2").RowHeight="300"
			    .Range("A2:F2").EntireRow.AutoFit 'Auto fitting row height
			    .Range("C2:E2").VerticalAlignment = xlTop 'Setting vertical alignment to the top for the second row of the sheet for columns C to G
			    .Range("C2:E2").HorizontalAlignment = xlLeft 'Setting horizontal alignment to the left for columns C to G
			    .Range("F2").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the center for screenshot column
			    .Range("F2").VerticalAlignment = xlCenter
			    .Range("A2:B2").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the center for Date and Deal# columns
			    .Range("A2:B2").VerticalAlignment = xlCenter
			    .Range("A1:B1").Columns.AutoFit

				.Cells(2,1) = now() 'writing Time Stamp to CSi results sheet
				.Cells(2,2) = CME_GetDealNum() 'writing Deal# to CSi results sheet
				.Cells(2,3) = generatedDocs 
				.Cells(2,4) = missingDoc 'Missing Documents Column
				.Cells(2,5) = xtraDoc 'Unexpected Documents Column
				.Cells(2,6) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
				
				.Cells.WrapText=true
		
		
			End With
		
		
		objWorkBook.SaveAs csiResFile 'Saving created csi results file
		objWorkBook.Close
		csiXL.Quit
		Set activeWSh = nothing
		Set preclosSh = Nothing
		Set closSh = Nothing
		Set objWorkBook = Nothing
		Set csiXL = Nothing
	
	Else 
		Set csiXL = CreateObject ("Excel.Application")
		csiXL.Visible = False
		Set objWorkBook = csiXL.Workbooks.Open(csiResFile) 'opening csi result file
		
		For iSheet = 1 To objWorkBook.Worksheets.Count
		    If Trim(UCase(objWorkBook.Worksheets(iSheet).Name)) = Trim(UCase(Win_Title_Field)) Then 'Checking if sheet exists
		        exists = True
		    End If
		Next
	
		If Not exists Then ' if exist = False adding sheet to the workbook and giving it a name
			objWorkBook.Worksheets.Add, objWorkBook.Worksheets(objWorkBook.Worksheets.Count)
			objWorkBook.Worksheets(objWorkBook.Worksheets.Count).Name = Win_Title_Field
		End If
		
		Set activeWSh = csiXL.ActiveWorkbook.Worksheets(Win_Title_Field)
		
		With activeWSh
				'Adding column headers to CSi results sheets
			    .Range("A1:F1") = Array("Execution Time", "Deal #", "Documents Appeared in Selection Logic", "Missing Expected Documents", "Unexpected Documents", "Screenshot")
			    .Range("A1:F1").Font.Bold = True
			    .Range("A1:F1").Interior.ColorIndex="40"
			    .Range("C1:F1").ColumnWidth="40"
			    .Range("A1:F1").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the left
			    '.Range("A2:F2").RowHeight="300"
			    .Range("A2:F2").EntireRow.AutoFit 'Auto fitting row height
			    .Range("C2:E2").VerticalAlignment = xlTop 'Setting vertical alignment to the top for the second row of the sheet for columns C to G
			    .Range("C2:E2").HorizontalAlignment = xlLeft 'Setting horizontal alignment to the left for columns C to G
			    .Range("F2").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the center for screenshot column
			    .Range("F2").VerticalAlignment = xlCenter
			    .Range("A2:B2").HorizontalAlignment = xlCenter 'Setting horizontal alignment to the center for Date and Deal# columns
			    .Range("A2:B2").VerticalAlignment = xlCenter
			    .Range("A1:B1").Columns.AutoFit

				.Cells(2,1) = now() 'writing Time Stamp to CSi results sheet
				.Cells(2,2) = CME_GetDealNum() 'writing Deal# to CSi results sheet
				.Cells(2,3) = generatedDocs 
				.Cells(2,4) = missingDoc 'Missing Documents Column
				.Cells(2,5) = xtraDoc 'Unexpected Documents Column
				.Cells(2,6) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
				
				.Cells.WrapText=true
		
		End With
		
		objWorkBook.Save'Saving csi results file
		objWorkBook.Close
		csiXL.Quit
		'Print "closing existing CSI result file"
		

	End If
		
	'******** Reporting CSi results ends here ****************************
	
	'Clicking Generate Documents button		
	Set GenDocBtn = CME_application.WebElement("html tag:=A","attribute/fieldName:=Generate Documents", "index:=0")
	If GenDocBtn.Exist(10) Then
		GenDocBtn.Highlight
		GenDocBtn.Click
		wait 2
		Call CME_DynamicWait()
		'On error resume next
		'Handling CSI Pop up starts here
		Call CME_CSi_PopUP()
		
		Set readyDocsWindow = CME_application.WebElement("class:=container","innertext:=Document is Ready.*", "visible:=True")
		If readyDocsWindow.Exist(20) Then
			Set docLink = CME_application.Link("html tag:=A", "class:=hyperlink", "innertext:=Click here to view the document.*", "visible:=True")
		
			docLink.Click
			wait 1
			Set errWndw = Browser("name:=CME-Onboarding").Dialog("regexpwndtitle:=Internet Explorer").WinObject("object class:=window").Static("text:=Cannot find .*")
			If errWndw.Exist(1) Then
				scrnShotTitle="CantFindFile"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				Call CME_CloseLatestOpenedBrowser()
				On Error Goto 0
				Call CME_ExitTest()
			Else 
				Call RefreshPDFPage()

			   	Set pdfPage=Browser("creationtime:=1").WinObject("regexpwndtitle:=AVPageView","visible:=True")
			   	Wait 1
				'strTitle=pdfPage.GetROProperty("title")
				If pdfPage.Exist(10)=True Then
					Wait 1
					scrnShotTitle = "RenderedDocs"
					
				    Call CaptureScreen(scrnShotTitle)
					Call CME_ReportScreenshot(i)
					Call CME_CloseLatestOpenedBrowser()
														
				Else 
					scrnShotTitle="DocsNotRendered"
					
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					Call CME_CloseLatestOpenedBrowser()
					'Reporter.ReportHtmlEvent micFail, Win_Title_Field, "-"& readyDocName &" Not Rendered" 'Report if PDF page doesn't exist
				End If
				Call CME_ClickButton("Done","")
			End If	
		Else 
			'Report Document is Ready window missing
			scrnShotTitle="DocIsReadyWindow_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest()
		End If
		
	Else 
	End If
	
	wait 1
	Set doneBtn = CME_application.WebElement("attribute/fieldName:=Done","html tag:=A","visible:=true")
	If doneBtn.Exist(10) Then
		doneBtn.Click 'Clicking on Done button
		wait 1
		If doneBtn.Exist(10) Then
			doneBtn.Click 'Clicking on Done button
			
		End If
	End If

	
	Set doneBtn = Nothing
	Set activeWSh = nothing
	Set objWorkBook = nothing
	Set csiXL = nothing
	

	
'********************************************************************
'Case name: CME_Verify_CSI_Docs_PushedToRelDocs
'Description: Verifies if the CSi Documents pushed to Related Docs successfully
'Created by : Muzaffar A.
'Modified by and date: 05/02/2019
'Note: pushedDocs() array comes from CME_Verify_CSI_Documents keyword

'********************************************************************* 	
	Case "CME_Verify_CSI_Docs_PushedToRelDocs"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		set gridBox=CME_application.WebElement("class:=gridBox","attribute/fieldName:=relDocsGridBox","visible:=true")
		If gridBox.Exist(20) Then
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set colDocName=CME_application.WebElement("class:=gridBoxColumn","index:=2","visible:=true")	'Description column			
			Set colDocNameContent=colDocName.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rcDocName=colDocNameContent.Count 'Getting the rowcount of the Document Name column
			
			actSts = CME_application.WebElement("html tag:=SPAN","innertext:=.* - Status: .*","index:=1").GetROProperty("innertext")
			actStsArr = split(actSts, ":")
			act = Trim(LCase(actStsArr(1)))
			intdealnum = Replace(actStsArr(0), " - Status", "")
			intdealnum = Replace(intdealnum, "Deal #", "")
	
			If act = "credit approved" Then
				pushedDocPkg = "Deal" & intdealnum & "_DocPkg_1.PDF"
			ElseIf act = "pre-closing" Then
				pushedDocPkg = "Deal" & intdealnum & "_DocPkg_2.PDF"
			End If
			
			docMatcher = 0
			For iBorr = 0 To rcDocName-1
				displayedDoc = Trim(colDocNameContent(iBorr).GetRoProperty("innertext"))
				If displayedDoc = pushedDocPkg Then
					docMatcher = docMatcher + 1
					Exit for
				End If
			Next
			
			If docMatcher = 0 Then
				
				scrnShotTitle = Replace(pushedDocPkg, ".PDF", "") & "_Not_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
			Else 
				ReportPassed(i)
			End If
		Else  
			scrnShotTitle="RelatedDocumentsGrid_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1		
		End If
		
		Set colDocNameContent=Nothing
		Set colDocName=Nothing
		set gridBox=Nothing






'********************************************************************
'Case name: CME_GetRate
'Description: Clicks on Get Rate button in Product Information screen and enters Association spread based on the Base Rate
'Created by : Muzaffar A.
'Modified by and date:
'*********************************************************************	
	Case "CME_GetRate"
		Keyword = True
	    Tcs_Executed = Tcs_Executed+1 
	    On error resume next
	    
	    'Set GetRateBtn = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Get Rate","visible:=true")
	    Set baseRt = CME_application.WebElement("attribute/fieldName:=ln_requested_rate").WebEdit("visible:=true")
		If baseRt.Exist(10) Then
			Call CME_ClickButton("Get Rate", "")
			wait 1
			Call CME_DynamicWait()
			bsrtVal = CDbl(baseRt.GetROProperty("value"))
			If bsrtVal <> "" AND Isnumeric(bsrtVal) = True AND bsrtVal > 0 Then
				scrnShotTitle = "GetRate"
			    Call CaptureScreen(scrnShotTitle)
			    CME_ReportScreenshot(i)
			Else 
				scrnShotTitle="BaseRate_Failed"
				Call CaptureFailedObject(CME_application, baseRt, scrnShotTitle)
				CME_ReportFailed(i)	
			End If
		Else 
			scrnShotTitle="BaseRateField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)	
			Call CME_ExitTest()
		End If
		
		Set baseRt = Nothing	
		Set GetRateBtn = Nothing

'********************************************************************
'Case name: CME_CustomerSearch
'Description: New Customer
'Created by : 
'Modified by and date: 
'*********************************************************************
	Case "CME_CustomerSearch"

  		Keyword = True
	  	CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	Call CME_DynamicWait()
		If Trim(Lcase(win_title_field)) = "customer number" Then
			Set srchType = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=SRCH_TYPE","index:=0").WebEdit("visible:=true")
			If srchType.Exist(2) Then
				srchType.Object.value = "Customer Number"
				srchType.DoubleClick
			Else 
				scrnShotTitle="SearchTypeDD_Not_Found"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
			End If
			
			
		End If
		
		 If Trim(LCase(field)) = "existing customer" Then
		    srchVal = value
			btnName = "Continue"			    
		 Else 
		 	srchVal = "hgkdsdj"
		 	btnName = "New"
		 End If
		
		Set textField=CME_application.WebElement("class:=textField","attribute/fieldName:=WRK_NAME_SEARCH","index:=0").WebEdit("visible:=true")
		If textField.Exist(60) Then
		    
		    textField.Set srchVal
		   
		    textField.Click
		     wait 1

		   Call CME_ClickButton("Search", "")
		   Call CME_DynamicWait()
		   Call CME_ClickButton(btnName, "")
		   If CME_application.WebElement("class:=label","innertext:=Entity Active in Other Deals.*","index:=0").Exist(2) Then
		   		Call CME_ClickButton("Yes", "")
		   End If 
		    
		Else 
			scrnShotTitle="SearchField_Not_Found"
    		Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			Call CME_ExitTest()
		End If
	    
        
		Set srchbutton = Nothing
		Set textField=nothing
		Set srchType = Nothing


'********************************************************************
'Case name: CME_RouteDeal
'Description: Route deal to activity 
'Created by : Muzaffar A.
'*********************************************************************	

	Case "CME_RouteDeal"
		Keyword = True
	 	BoolfieldExist=False
	    On error resume next
	    Call CME_DynamicWait()
	    Set newAct = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=NEXTPHASE","index:=0").WebEdit("visible:=true")
	    If newAct.Exist(30) Then
	    	strNxtAct = newAct.GetROProperty("value")
    		If strNxtAct <> "" Then
		    	Call CME_GetApplicationNumber()
'				Set prcCntr = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=NEXTPROCCTR","index:=0").WebEdit("visible:=true")
'				If LCase(prcCntr.GetROProperty("value")) <> "plains land bank" Then
'					prcCntr.Click
'					prcCntr.Object.value = "Plains Land Bank"
'					prcCntr.Click
'				End If 
				
				
				
		    	Set userDD = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=NEXTUSER","index:=0").WebEdit("visible:=true")
		    	If userDD.Exist(5) Then
		    		userDD.Click
		    		userDD.Object.value = Environment.value("usrFulNme") 'Getting user full name from database
		    		userDD.Click
		    		
		    		field = newAct.GetROProperty("value")
		    		scrnShotTitle = "Routing"
			    	Call CaptureScreen(scrnShotTitle)
			    	CME_ReportScreenshot(i)
					Call CME_ClickButton("Finish|Continue", "")
					If Trim(LCase(Browser_Name)) = "chrome" Then
		    			Set button=CME_application.Link("html tag:=A","innertext:=Minimize","visible:=true","index:=0") 'Modified by Muzaffar A.
				    		
				    		
			    	Else 	
			    		Set button = CME_application.WebElement("html tag:=A","tabindex:=0","attribute/fieldName:=Minimize","visible:=true","index:=" & index) 'Modified by Muzaffar A.
			    		
			   		End If
					If button.Exist(2) Then
						scrnShotTitle="incompleteData"
				    	Call CaptureScreen(scrnShotTitle)
						CME_ReportFailed(i)
						Call CME_ExitTest()
					End If
					Call CME_DynamicWait()
					
		    	Else 
		    		scrnShotTitle="userDD_Not_Found"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
		    	End If
	    	Else 
	    		field = "New Activity DD Empty"
	    		scrnShotTitle="NewActDD_Value_Empty"
		    	Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
	    	End If
	    Else 
	    	scrnShotTitle="newActDD_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
	    End If
		   
	Set button = Nothing
	Set userDD = Nothing
	Set newAct = Nothing

'********************************************************************
'Case name: CME_CalculatePayment
'Description: Clicks on Calculate Payment
'Created by : Muzaffar A.
'Modified by and date:
'value=Borrower Stated Rate
'*********************************************************************	
	Case "CME_CalculatePayment"
		Keyword = True
	    Tcs_Executed = Tcs_Executed+1 
	    On error resume next
	    
	    Call CME_ClickButton("CALCULATE PAYMENT", "")
	    wait 1
	    Call CME_DynamicWait()
	    If CME_application.WebElement("class:=label", "html tag:=DIV", "innertext:=Unsuccessful calculation.*", "visible:=true").Exist(1) Then
	    	scrnShotTitle="Unsuccessful"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			Call CME_ExitTest()
	    End If
	    Set calcMsg = CME_application.WebElement("class:=label", "html tag:=DIV", "innertext:=.*Successful Calculation.*", "visible:=true")
	    If calcMsg.Exist(30) Then
	    	scrnShotTitle = "SuccessCalculation"
	    	Call CaptureScreen(scrnShotTitle)
	    	CME_ReportScreenshot(i)
	    	Call CME_ClickButton("OK", "")
	    	Call CME_DynamicWait()
	    Else 
			scrnShotTitle="CalculationFailed"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)	
			
			Call CME_ExitTest()
						
	    End If
	   
			
		Set calcMsg = Nothing


'********************************************************************
'Case name: CME_LockRate
'Description: tests Lock Rate functionality
'Created by : Muzaffar A.
'Modified by and date:
'value=Borrower Stated Rate
'*********************************************************************	
	Case "CME_LockRate"
		Keyword = True
	    Tcs_Executed = Tcs_Executed+1 
	    On error resume next
	    If value <>"" Then
			Set locktype = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=INDEX_RATE_LOCK_TYPE_DESC","index:=0").WebEdit("visible:=true")
		    If locktype.Exist(10) Then
		    	locktype.Object.value = value
		    	locktype.DoubleClick
		    Else 
		    	scrnShotTitle="lockRateTypeDD_NotFound"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)	
		    End If
	   	End If

	    Call CME_ClickButton("Lock Rate", "")
	    Call CME_DynamicWait()
	    wait 1
	    Set lckinDate = CME_application.WebElement("class:=textField","attribute/fieldName:=rate_lock_in_date","index:=0").WebEdit("visible:=true")
	    If lckinDate.Exist(10) Then
	    	lckVal = lckinDate.GetROProperty("value")
	    	If lckVal <> "" Then
	    		scrnShotTitle = "lockrateSuccess"
	    		Call CaptureScreen(scrnShotTitle)
	    		CME_ReportScreenshot(i)
	    	Else 
	    		scrnShotTitle = "lockrateFailed"
	    		Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				Call CME_ExitTest()	
	    	End If
	    	
	    Else 
			scrnShotTitle="LockinDateFieldNotFound"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)	
			Call CME_ExitTest()			
	    End If
	   
			
		Set lckinDate = Nothing
		Set locktype = Nothing

'********************************************************************
'Case name: CME_ECM_Upload_Doc
'Description: To Handle Upload Docin Related doc 
'Created by : Shruthi & Vaishnavi
'Modified by and date:
'value: File path
'field: Description of the uploaded file
'*********************************************************************
	
	Case "CME_ECM_Upload_Doc"
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call CME_ClickButton("Add", "")
 		Call CME_DynamicWait()
 		wait 2
 		''CME_application.WebFile("name:=file").Highlight
 		BoolfieldExist=CME_application.WebFile("name:=file").Exist(5)
		Set ofs = CreateObject("Scripting.FileSystemObject")
		If ofs.FileExists(value) Then
		    If BoolfieldExist=True Then	
		   CME_application.WebFile("name:=file").Highlight
		   	''	Setting.Webpackage("Replaytype") = 2
			    CME_application.WebFile("name:=file").set value 
			  
			  ''  Setting.Webpackage("Replaytype") = 1
			    wait 1
				
				Set label=CME_application.WebElement("attribute/fieldName:=Description:","visible:=true")
		  		If label.Exist(10) Then
					'label.highlight
'			  		Set objWebEdit=label.Object.PreviousSibling.lastchild
					Set descFld = CME_application.WebElement("class:=container","html tag:=DIV","innertext:=Upload Multiple Files.*","visible:=True").WebEdit("index:=1","visible:=True")
		           descFld.Highlight
		           '' descFld.Click
		            Wait 1
					descFld.Set field
					wait 1
					descFld.Click
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
'					Set objWebEdit=CME_application.WebEdit("value:="&field,"visible:=true","index:=0")
'					objWebEdit.Click
'					ReportPassed(i)
				Else 
					scrnShotTitle="DialogBox_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest() 
				End If
			Else 
				scrnShotTitle="Document_Not_Found"
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest() 		
			End If
		End  If
		Call CME_ClickButton("OK", "")	
		

		Set descFld = Nothing
		Set label = Nothing
		Set ofs = Nothing
		
	
	Case "CME_ECM_Upload_Docs"
	    Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call CME_ClickButton("Add", "")
 		Call CME_DynamicWait()
 		Intindex = win_title_field
 		wait 2
 		''CME_application.WebFile("name:=file").Highlight
 		BoolfieldExist=CME_application.WebFile("name:=file","index:="&Intindex).Exist(5)
		Set ofs = CreateObject("Scripting.FileSystemObject")
		''msgbox ofs.FileExists(value)
		If ofs.FileExists(value) Then
		    If BoolfieldExist=True Then	
		   CME_application.WebFile("name:=file","index:="&Intindex).Highlight
		   	''	Setting.Webpackage("Replaytype") = 2
			    CME_application.WebFile("name:=file","index:="&Intindex).set value 
			  
			  ''  Setting.Webpackage("Replaytype") = 1
			    wait 1
				
				Set label=CME_application.WebElement("attribute/fieldName:=Description:","visible:=true","index:=0")
		  		If label.Exist(10) Then
					''label.highlight
'			  		Set objWebEdit=label.Object.PreviousSibling.lastchild
					Set descFld = CME_application.WebElement("class:=container","html tag:=DIV","innertext:=Upload Multiple Files.*","visible:=True","index:=0").WebEdit("index:=1","visible:=True")
		         'descFld.Highlight
		           '' descFld.Click
		            Wait 1
		            descFld.Set " "
					descFld.Set field
					wait 1
					descFld.Click
					Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
'					Set objWebEdit=CME_application.WebEdit("value:="&field,"visible:=true","index:=0")
'					objWebEdit.Click
'					ReportPassed(i)
				Else 
					scrnShotTitle="DialogBox_Not_Found"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest() 
				End If
			Else 
				scrnShotTitle="Document_Not_Found"
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
				On error goto 0
				Call CME_ExitTest() 		
			End If
		End  If
		Call CME_ClickButton("OK", "")	
		

		Set descFld = Nothing
		Set label = Nothing
		Set ofs = Nothing

'********************************************************************
'Case name: CME_ECM_AssociateDoc
'Description: To Handle ECM parameters
'Created by : Shruthi & Vaishnavi
'win_title_field: Attribute to  be filled in Doc folder and doc name i.e collateral or Appraisal
'field:"Entity:||Collateral:||Product:" field names
'value:"SAILA0729204732.*||Collateral #1.*||Facility #1.*" Attributes to the field 
'*********************************************************************	

Case "CME_ECM_AssociateDoc"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    
	    If instr(Win_Title_Field, "||")>0 Then 'If multiple selections from dropdown needed we can specify them in value with '||' delimeter
			item=split(Win_Title_Field, "||")

			CME_application.WebElement("class:=gridBox","innertext:=document_folder.*","index:=0").WebElement("class:=gridBoxCell","innertext:="&item(0),"index:=0").Click

			wait 0.5
'			Set docNameDD = CME_application.WebElement("class:=label","innertext:=Document Name:", "visible:=true").Object.NextSibling.firstchild.NextSibling
'			docNameDD.Click
'			docNameDD.Value = item(1) '
'			wait 0.5
'			docNameDD.Click
			Set docNameDD = CME_application.WebElement("class:=container","html tag:=DIV","innertext:=Associate Document.*", "visible:=True").WebEdit("index:=4","visible:=True")
			docNameDD.Object.Value = item(1)
			wait 0.5
			docNameDD.DoubleClick
			
			    		
		Else 
			'Report missing test data - Exittest
			scrnShotTitle="MissingTestData"
			CME_ReportFailed(i)
			On Error Goto 0
			Call CME_ExitTest()
		End If
		
		'Selecting Entity
		CME_application.WebElement("class:=gridBox","innertext:=Entity.*","index:=0").WebElement("class:=gridBoxCell","innertext:="&field,"index:=0").Click

		If instr(value, "||")>0 Then 'If multiple selections from dropdown needed we can specify them in value with '||' delimeter
			ddval=split(Value, "||") ' Splitting them by delimeter
			
			colInx = ddval(0) - 1
			wait 0.5
			CME_application.WebElement("class:=gridBox","innertext:=Collateral.*","index:=1").WebElement("class:=gridBoxCell","innertext:=.*","index:="& colInx).Click
			
			prodInx = ddval(1) - 1
			wait 0.5
			CME_application.WebElement("class:=gridBox","innertext:=ProductFacility.*","index:=1").WebElement("class:=gridBoxCell","innertext:=.*","index:="& prodInx).Click
			
	
		Else 
				'Report missing test data - Exittest
				scrnShotTitle="MissingTestData"
				CME_ReportFailed(i)
				On Error Goto 0
				Call CME_ExitTest()
		End If
		
		
		Call CME_ClickButton("Continue","1")
		Call CME_DynamicWait()
		
		
		'Checking for Please Select ... message in case of incomelete data selections
	    Set inCmptMsg = CME_application.WebElement("class:=container","html tag:=DIV","innertext:=MessagePlease .*", "visible:=True")
	    If inCmptMsg.Exist(0.5) Then
	    	field = inCmptMsg.GetROProperty("innertext")
			CME_ReportFailed(i)
			On Error Goto 0
			Call CME_ExitTest()
	    Else 
	    	Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    End If
	    
'********************************************************************
'Case name: CME_VerifyGridCellValue
'Description: Verifies Cell value based on onother cell valu in the same row different column
'Created by : Muzaffar A
'Modified by and date: 
'Win_Title_Field = gridbox logical name
'field = identifier column name||identifier cell value
'value = "Expected Column name||Cell Value"
'*********************************************************************	

Case "CME_VerifyGridCellValue"
	Keyword = True
    CME_TS_Executed=CME_TS_Executed+1
    BoolfieldExist=False
    On error resume Next
    Arg=Split(Win_Title_Field, "||")
    
	propVal=CME_Value_from_Repository(Arg(0),"Value")
    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
	Set objDesc = Description.Create 'Creating description for the object
	For iProp = 0 To UBound(propValArr) 
	arr = split(propValArr(iProp),":=")  
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If				
	Next
	objDesc("visible").Value=true 'Adding Visible property to collection of description
	
	set gridBox = CME_application.WebElement(objDesc)
	
	'arrIdnCol = split(field, "||")
	IdntfrColName = UCase(Arg(1))
	IdntfrCell = field
	ArrExpCol = split(value, "||")
	expColName = UCase(ArrExpCol(0))
	expCellVal = ArrExpCol(1)
	
	If gridBox.Exist(20) Then
		'Description for column header name
		Set colheader=description.Create
		colheader("micClass").Value="WebElement"
		colheader("class").Value="gridBoxColumnHeader"
		
		'Getting the count of columns in the gridbox
		Set obj1=gridBox.Childobjects(colheader)
		columnCount=obj1.count
		'Getting the column names along with their position number in the grid to dictionary object
		Set dict = CreateObject("Scripting.Dictionary")
		For icol = 0 To columnCount-1
			dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
		Next
		
		'We specify column name in field and fetch it's position number in the grid from the dictionary object
		colNum=Trim(dict.Item(IdntfrColName))		
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rowcount=objCell.Count 'Getting the rowcount of the grid
	
		For igrdRw = 0 To rowcount - 1
		
			cellValue = objCell(igrdRw).GetROProperty("innertext")
			If ucase(trim(cellValue))=ucase(trim(IdntfrCell)) Then
	            idntfrRowNum = igrdRw'CME_resPassed+1                 
	        	Exit For
	        End If
		Next
		
		colNum=Trim(dict.Item(expColName))
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		
		actCellVal = objCell(idntfrRowNum).GetROProperty("innertext")
		
		If ucase(trim(actCellVal))=ucase(trim(expCellVal)) Then
			Call ReportPassed(i)
		Else 
			scrnShotTitle="Value_Not_Matched"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If
		
		
		
	Else 
		scrnShotTitle="Grid_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
	End If

Set colheader = Nothing
Set obj1 = Nothing
Set dict = Nothing
Set gridBoxColumn = Nothing
Set objCell = Nothing
set gridBox = Nothing
Set objDesc = Nothing


'********************************************************************
'Case name: CME_ClickGridCellValue
'Description: Click Cell value based on onother cell valu in the same row different column
'Created by : Muzaffar A
'Modified by and date: 
'Win_Title_Field = gridbox logical name
'field = identifier column name||identifier cell value
'value = "Expected Column name||Cell Value"
'*********************************************************************	

Case "CME_ClickGridCellValue"
	Keyword = True
    CME_TS_Executed=CME_TS_Executed+1
    BoolfieldExist=False
    On error resume Next
    Arg=Win_Title_Field
	propVal=CME_Value_from_Repository(Arg,"Value")
    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
	Set objDesc = Description.Create 'Creating description for the object
	For iProp = 0 To UBound(propValArr) 
	arr = split(propValArr(iProp),":=")  
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If				
	Next
	objDesc("visible").Value=true 'Adding Visible property to collection of description
	
	set gridBox = CME_application.WebElement(objDesc)
	
	arrIdnCol = split(field, "||")
	IdntfrColName = UCase(arrIdnCol(0))
	IdntfrCell = arrIdnCol(1)
	expColName = UCase(value)
	
	If gridBox.Exist(20) Then
		'Description for column header name
		Set colheader=description.Create
		colheader("micClass").Value="WebElement"
		colheader("class").Value="gridBoxColumnHeader"
		
		'Getting the count of columns in the gridbox
		Set obj1=gridBox.Childobjects(colheader)
		columnCount=obj1.count
		'Getting the column names along with their position number in the grid to dictionary object
		Set dict = CreateObject("Scripting.Dictionary")
		For icol = 0 To columnCount-1
			dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
		Next
		
		'We specify column name in field and fetch it's position number in the grid from the dictionary object
		colNum=Trim(dict.Item(IdntfrColName))		
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rowcount=objCell.Count 'Getting the rowcount of the grid
	
		For igrdRw = 0 To rowcount - 1
		
			cellValue = objCell(igrdRw).GetROProperty("innertext")
			If ucase(trim(cellValue))=ucase(trim(IdntfrCell)) Then
	            idntfrRowNum = igrdRw'CME_resPassed+1                 
	        	Exit For
	        End If
		Next
		
		colNum=Trim(dict.Item(expColName))
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		
		objCell(idntfrRowNum).Click
		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		
		
	Else 
		scrnShotTitle="Grid_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
	End If

Set colheader = Nothing
Set obj1 = Nothing
Set dict = Nothing
Set gridBoxColumn = Nothing
Set objCell = Nothing
set gridBox = Nothing
Set objDesc = Nothing


'********************************************************************
'Case name: CME_ECM_ArchiveDoc
'Description: Archives Document in Rel. Docs screen based on the Document Description
'Created by : Muzaffar A
'Modified by and date: 
'field = Document Description
'*********************************************************************	

Case "CME_ECM_ArchiveDoc"
	Keyword = True
    CME_TS_Executed=CME_TS_Executed+1
    On error resume Next
    
	set gridBox = CME_application.WebElement("class:=gridBox", "attribute/fieldname:=relDocsGridBox", "visible:=true")
	
	If gridBox.Exist(20) Then
		'Description for column header name
		Set colheader=description.Create
		colheader("micClass").Value="WebElement"
		colheader("class").Value="gridBoxColumnHeader"
		
		'Getting the count of columns in the gridbox
		Set obj1=gridBox.Childobjects(colheader)
		columnCount=obj1.count
		'Getting the column names along with their position number in the grid to dictionary object
		Set dict = CreateObject("Scripting.Dictionary")
		For icol = 0 To columnCount-1
			dict.Add Trim(Ucase(obj1(icol).getRoProperty("innertext"))),icol+1
		Next
		
		'We specify column name in field and fetch it's position number in the grid from the dictionary object
		colNum=Trim(dict.Item("DESCRIPTION"))		
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		Set gridcell=description.Create
		gridcell("micClass").Value="WebElement"
		gridcell("class").Value="gridBoxCell"
		gridcell("visible").Value=true
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		rowcount=objCell.Count 'Getting the rowcount of the grid
	
		For igrdRw = 0 To rowcount - 1
		
			cellValue = objCell(igrdRw).GetROProperty("innertext")
			If ucase(trim(cellValue))=ucase(trim(field)) Then
	            idntfrRowNum = igrdRw'CME_resPassed+1                 
	        	Exit For
	        End If
		Next
		
		colNum=Trim(dict.Item("ID"))
		'We use column number as an index gridBoxColumn object below
		indx=colNum-1
		
		Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
		Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
		
		objCell(idntfrRowNum).Click
		wait 0.5
		
		Call CME_ClickButton("Archive", "")
		Call CME_DynamicWait()
		
		Set hstKywrdWnd = CME_application.WebElement("class:=container", "innertext:=Host Keywords.*", "visible:=true")
		If hstKywrdWnd.Exist(10) Then
			If Trim(value) <> "" Then
				Set label = CME_application.WebElement("attribute/fieldName:=Document Creation Date","visible:=true","index:=0")
				Set objWebEdit=label.Object.PreviousSibling.lastchild
				strFieldval = objWebEdit.Title
				Call CME_FetchValueToGlobalVariable(value, strFieldval)
			End If
			
			Call CME_ClickButton("OK", "")
			Call CME_DynamicWait()
			'We specify column name in field and fetch it's position number in the grid from the dictionary object
			colNum=Trim(dict.Item("STATUS"))		
			'We use column number as an index gridBoxColumn object below
			indx=colNum-1
			Set gridcell=description.Create
			gridcell("micClass").Value="WebElement"
			gridcell("class").Value="gridBoxCell"
			gridcell("visible").Value=true
			Set gridBoxColumn=gridBox.WebElement("class:=gridBoxColumn","index:="&indx)				
			Set objCell=gridBoxColumn.Childobjects(gridcell) 'Setting collection of objects for gridboxcell class objects
			rowcount=objCell.Count 'Getting the rowcount of the grid
			cellValue = objCell(igrdRw).GetROProperty("innertext")
				If ucase(trim(cellValue))=ucase(trim("ARCHIVED")) Then
		            Call ReportPassed(i) 
		        Else 
					scrnShotTitle="Archiving_Failed"
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					CME_resFailed=CME_resFailed+1		        
		        End If
			
		End If
		
		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		
		
	Else 
		scrnShotTitle="Grid_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
	End If

Set colheader = Nothing
Set obj1 = Nothing
Set dict = Nothing
Set gridBoxColumn = Nothing
Set objCell = Nothing
set gridBox = Nothing
Set objDesc = Nothing

'********************************************************************
'Case name: CME_GetReleaseInfo
'Description: Gets CME release info 
'Created by : Pavan kumar
'Modified by and date: 06/24/2020

'*********************************************************************	 

Case "CME_GetReleaseInfo"
Keyword=true
CME_application.WebElement("class:=mainMenuButton","visible:=True","index:=0","innertext:=Help").Click
CME_application.WebElement("class:=menuButtonText","visible:=True","index:=0","innertext:=About Credit Management Enterprise").Click
intRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=Release.*").GetROProperty("innertext")
intSQLRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=SQL.*").GetROProperty("innertext")
intPromotion=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=PROMOTIO.*").GetROProperty("innertext")


CME_application.WebElement("html tag:=A","visible:=True","index:=0","innertext:=OK").Click

Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(resPath)
Set objWorksheet = objWorkbook.Worksheets(1)


objWorksheet.Cells(2,1).Value="Release info - "&intRelease
objWorksheet.Cells(3,1).Value= "SQL info - "&intSQLRelease
objWorksheet.Cells(2,2).Value= "Promotion info - "&intPromotion

objWorkbook.save
objWorkbook.Application.Quit


	Set objWorksheet = Nothing
	Set objWorkbook = Nothing
	Set objExcel = Nothing

	
'********************************************************************
'Case name: CME_SearchInWebNav
'Description: Searches for Customer or Deal in Web Navigator
'Created by : Muzaffar A.
'Modified by and date: 07/19/2019

'********************************************************************* 
	Case "CME_SearchIn_LIQ_WebNav"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		Set webNavSrch = WebNavigator.WebEdit("html tag:=INPUT","html id:=search","visible:=True")
		If webNavSrch.Exist(10) Then
			webNavSrch.Click
			set mySendKeys = CreateObject("WScript.shell")
			mySendKeys.SendKeys(value)
			mySendKeys.SendKeys("{ENTER}")
			wait 5
			Set webNavResLink = WebNavigator.Link("html tag:=A","innertext:="& value &".*","visible:=true")
			If webNavResLink.Exist(5) Then
				webNavResLink.Click
				ReportPassed(i)
		    	'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle=field&"_Not_Found"
				Call CaptureScreen(scrnShotTitle)
	    		CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
			End If
		Else 
			scrnShotTitle="SearchField_Not_Found"
			Call CaptureScreen(scrnShotTitle)
    		CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If
	

'********************************************************************
'Case name: CME_WebNav_VerifyData
'Description: Verifies Customer Info or Deal Info in Web Navigator
'Created by : Muzaffar A.
'Modified by and date: 07/19/2019

'********************************************************************* 
	Case "CME_WebNav_VerifyData"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
		Set objElWebNav = WebNavigator.WebElement(objDesc)
		If objElWebNav.Exist(10) Then
			strObjVal = objElWebNav.GetROProperty("innertext")
			
			If UCase(Trim(strObjVal)) =  UCase(Trim(value)) Then
				ReportPassed(i)
			    'CME_resPassed='CME_resPassed+1
			Else 
				scrnShotTitle=field&"_Value_Not_Matched"
				Call CaptureFailedObject(CME_application, ybsField, scrnShotTitle)
	    		CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1
			End If
		Else 
			scrnShotTitle=field&"_Field_Not_Found"
			Call CaptureScreen(scrnShotTitle)
    		CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If

 
 
'********************************************************************
'Case name: CME_Launch_LIQ_WebNav
'Description: Clicks on buttons in LIQ Web Navigator page
'Created by : Muzaffar A.
'Modified by and date: 07/19/2019

'*********************************************************************
	Case "CME_Launch_LIQ_WebNav"
		Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    On error resume next
		field = "LIQWEBNAVIGATOR"
		CME_LaunchApplication()
		WebNavigator.Sync



'********************************************************************
'Case name: CME_OBS_Building_Wait
'Description: Logs in to Booking screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************

Case "CME_OBS_Building_Wait"
	Keyword = True
	CME_TS_Executed=CME_TS_Executed+1
	Set objScrnNotSaved = CME_application.WebElement("html tag:=DIV","class:=container","innertext:=Screen Not SavedScreen.*","visible:=true")
	If objScrnNotSaved.Exist(3) Then
		CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=No","html tag:=A","visible:=true").Click
	End  if
	'wait 5
	Set cnfrmWndw = CME_application.WebElement("html tag:=DIV","class:=container","innertext:=ConfirmBy clicking the Booking link.*|Are you ready to create the booking.*","visible:=true")
		If cnfrmWndw.Exist(10) Then
			CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=Yes","html tag:=A","visible:=true").Click
		End If
		Wait 2
'		Set cnfrmOKWndw	= CME_application.WebElement("html tag:=DIV","class:=label","innertext:=.*Servicing Group Selection","visible:=true")     ''''//// clicking on OK button on servicing group popup
'			If cnfrmOkWndw.Exist(3) Then
'			CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true").Click
'			End If
'	Set cnfrmOKWndw	= CME_application.WebElement("html tag:=DIV","class:=label","innertext:=.*Servicing Group Selection","visible:=true")     ''''//// clicking on OK button on servicing group popup
'		obsctr=4
'		For i = 0 To obsctr-1 Step 1
'			If cnfrmOkWndw.Exist(3) Then
'			CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true").Click
'			End If
'		Next
		
	Set objLoading = CME_application.Image("file name:=\?_twr_=loadcircle\.gif","visible:=True")
	Set objDialog = CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true").WebEdit("html tag:=TEXTAREA","index:=0","visible:=true")
	Set servGroupsWndw = CME_application.WebElement("class:=container",	"innertext:=.*- Servicing Group Selection.*", "index:=0","visible:=true")
	
	Do while  objLoading.Exist(1)
		
		If objDialog.Exist(1) Then
			errMsg = objDialog.GetROProperty("innertext")
			scrnShotTitle="ErrorWhileBuilding"
			Call CaptureScreen(scrnShotTitle)
 			testdescription = testdescription & vbCrLf & errMsg
			CME_ReportFailed(i)
			Reporter.ReportHtmlEvent micFail, "Building OBS", "Error Found"
			On error goto 0
			Call CME_ExitTest() 
		ElseIf servGroupsWndw.Exist(1) Then
			CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true").Click
		
		
		End If
		
	Loop		       

Set servGroupsWndw = nothing
Set objDialog = nothing
Set objLoading = Nothing
Set cnfrmWndw = Nothing
Set objScrnNotSaved = Nothing
'********************************************************************
'Case name: CME_Booking_Login
'Description: Logs in to Booking screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************

Case "CME_Booking_Login"
	Keyword = True
	CME_TS_Executed=CME_TS_Executed+1
	CME_OBS_LoadingCircle()
	Set objDialog = CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true")
	If objDialog.Exist(1) Then
		bkngErrMsg = objDialog.GetROProperty("innertext")
		If instr(LCase(bkngErrMsg), "error") > 0 Then
			scrnShotTitle="Errors"
			Call CaptureScreen(scrnShotTitle)
			reporter.ReportHtmlEvent micFail, "Booking Login Page", "Error Found"
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 
		End If
	End If
	
	Call CME_OBS_LoadingCircle()
	On error resume next
	If CME_application.WebElement("html tag:=H3","innertext:=Sign In","visible:=true").Exist(2) Then
		Set login_username = CME_application.WebEdit("html id:=user_login", "html tag:=INPUT", "visible:=True")
		Set login_password = CME_application.WebEdit("html id:=user_pass", "html tag:=INPUT", "visible:=True")
			BoolfieldExist=login_username.Exist(30) and login_password.Exist(5)' and login_button.Exist(5)
			
			pwd=CME_LoginData() 'Function gets called and returns password value with respect to username entered in field cell
		If BoolfieldExist=true and pwd<>"" Then
			login_username.Set Environment.Value("UserName")
			login_password.SetSecure pwd
			
			CME_application.WebCheckBox("html id:=rememberme", "html tag:=INPUT", "visible:=True").Set "ON"
			CME_application.WebButton("html tag:=INPUT", "name:=Sign In","visible:=True").Click
		ElseIf pwd="" Then
			scrnShotTitle="Password_field_is_empty"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 
		ElseIf BoolfieldExist=false Then
			scrnShotTitle="One_of_the_Login_Objects_Not_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			
		End If
		Set login_username=nothing
		Set login_password=nothing
	End If
	Call CME_LoadingCircle()
	CME_application.WebElement("html tag:=SPAN","innertext:=Booking","index:=0","visible:=true").Click
	If CME_application.WebElement("class:=label","innertext:=Screen Not Saved","index:=0","visible:=true").Exist(5) Then
		CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=No","html tag:=A","visible:=true").Click
	End If 
	Call CME_OBS_LoadingCircle()
	

'********************************************************************
'Case name: CME_Booking_VerifyCards
'Description: Verifies Cards and checks  in Booking screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	    
Case "CME_Booking_VerifyCards"
	Keyword = True
	CME_TS_Executed=CME_TS_Executed+1
	On error resume next
	Arg=field
	propVal=CME_Value_from_Repository(Arg,"Value")
	propValArr=split(propVal, "||") 'Splitting property values fetched from OR
	Set objDesc = Description.Create 'Creating description for the object
	For iProp = 0 To UBound(propValArr) 
		arr = split(propValArr(iProp),":=") 
		If arr(1) <> "" Then 
			objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
		End If 
	Next
	objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
	
	Set objCard=CME_application.WebElement(objDesc) ' Modified by Muzaffar A. 
	If objCard.Exist(5) Then
		Set objCmplt = objCard.WebElement("html tag:=DIV", "class:=highcharts-container", "visible:=True")
	 	If objCmplt.Exist(2) Then
	 		completion = LCase(objCmplt.GetROProperty("innertext"))
		 	If Instr(1, completion, "complete​100%") > 0 Then
		 		'Check for links in the card
				countNoErr = 0
				errLinks = ""
				
				Set objLink=description.Create
				objLink("MicClass").Value="Link"
				objLink("html tag").Value="A"
				objLink("class").Value="list-group-item.*"
				objLink("visible").Value=true
				
				Set Arrlinks = objCard.Childobjects(objLink)
				linkCount = Arrlinks.count
				For iLink = 0 To linkCount - 1
					Set objIcon = Arrlinks(iLink).WebElement("html tag:=SPAN","visible:=True")
					statusIcon = objIcon.Object.currentStyle.backgroundColor
					If statusIcon = "#dc3545" Then
						errLinkName = Arrlinks(iLink).GetROProperty("Innertext")
						'Reporter.ReportEvent micFail, "Error Detected - ", errLinkName
						errLinks = errLinks & vbcrlf & errLinkName
						countNoErr = countNoErr + 1
					 
					End If
				
				Next
				
		 		If countNoErr > 0 Then
		 			scrnShotTitle="ErrorLinks"
					Call CaptureScreen(scrnShotTitle)
		 			testdescription = testdescription & vbCrLf & errLinks
					CME_ReportFailed(i)
					
					CME_resFailed=CME_resFailed+1
					On error goto 0
					Call CME_ExitTest() 
		 		Else 
		 			ReportPassed(i)
		 		End If
		 		
		 	Else 
		 		scrnShotTitle = "Completion_Chart_Failed"
	 			Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				On error goto 0
				Call CME_ExitTest() 
		 	End If
		 	
		Else 
	 		'Report Completion Chart Not Found
	 		scrnShotTitle = "Completion_Chart_NotFound"
 			Call CaptureScreen(scrnShotTitle)
			testdescription = testdescription & ": Chart Completion Failed"
			CME_ReportFailed(i)
	 	End If	
		 	
	Else 
		'Report Card Not Found
		scrnShotTitle = "Card_NotFound"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		On error goto 0
		Call CME_ExitTest() 
	End If


	Set objIcon = Nothing
	Set objLink = Nothing
	Set objCmplt = Nothing
	Set objCard = Nothing
	Set objDesc = Nothing	    
	    
'********************************************************************
'Case name: CME_OBS_Booking
'Description: Verifies Cards and checks  in Booking screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	  	    
	Case "CME_OBS_Booking"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1   
	    Set bookBtn = CME_application.WebButton("html tag:=BUTTON","name:=Book Customer and Deals|Book Customer, Deals, and Facilities", "type:=submit","index:=0","visible:=True")
		If bookBtn.Exist(20) Then
			bookBtn.Click
			Set prgbar = CME_application.WebElement("html id:=progress-bar","visible:=True")
			If prgbar.Exist(30) Then
				
				Do Until lcase(stsClr) = "#76ce60" OR lcase(stsClr) = "#dc4f63"
					stsClr = prgbar.Object.currentStyle.backgroundColor
				Loop
				Set stsMsg = CME_application.WebElement("html id:=progress-bar-message","visible:=True")
				If stsMsg.Exist(20) Then
					strMsg = stsMsg.GetROProperty("innertext")
					If Lcase(Trim(strMsg)) = "success!" Then
						Call CaptureScreen("OBS_Booked")
		    			CME_ReportScreenshot(i)
					Else 
						scrnShotTitle = "Booking_Failed"
						Call CaptureScreen(scrnShotTitle)
						testdescription = testdescription & vbCrLf & strMsg
						CME_ReportFailed(i)
						On error goto 0
						Call CME_ExitTest()
					End If
				End If
			Else 
				scrnShotTitle = "Progressbar_NOT_Found"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				On error goto 0
				Call CME_ExitTest()
			End If
		Else 
			scrnShotTitle = "BookBtn_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)	
			On error goto 0
			Call CME_ExitTest()			
		End If
	    
	    
	    Set stsMsg = Nothing
	    Set prgbar = Nothing
	    Set bookBtn = Nothing
	    
	    
	    
'********************************************************************
'Case name: CME_OBS_Clk_Link
'Description: Clicks links in OBS screens
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	    
	Case "CME_OBS_Clk_Link"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1   
		On error resume next
		If value<>"" Then
			indx = value
		Else 
			indx = 0
		End If
		
		If Trim(Win_Title_Field) <> "" Then
			Arg=Win_Title_Field
			propVal=CME_Value_from_Repository(Arg,"Value")
			propValArr=split(propVal, "||") 'Splitting property values fetched from OR
			Set objDesc = Description.Create 'Creating description for the object
			For iProp = 0 To UBound(propValArr) 
				arr = split(propValArr(iProp),":=") 
				If arr(1) <> "" Then 
					objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
				End If 
			Next
			objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
			
			Set objCard=CME_application.WebElement(objDesc) ' Modified by Muzaffar A. 
			Set objLink = objCard.Link("html tag:=A", "name:=" & field, "visible:=True", "index:="&indx)
		Else 
			Set objLink = CME_application.Link("html tag:=A", "name:=" & field, "visible:=True", "index:="&indx) ' Modified by Muzaffar A.		
		End If
		
			
	    If objLink.Exist(20) Then
	    	'objLink.Highlight
	    	objLink.Click
	    	ReportPassed(i)
	    Else 
			scrnShotTitle = "Link_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 			
	    End If

	Set objLink = Nothing
	Set objDesc = Nothing

'********************************************************************
'Case name: CME_OBS_GetFieldValue
'Description: fetches field value in OBS screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	   

Case "CME_OBS_GetFieldValue"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	
  		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
  		
  		If Trim(LCase(Win_Title_Field)) = "weblist" Then
  			Set obsFld=CME_application.WebList(objDesc)
  		ElseIf Trim(LCase(Win_Title_Field)) = "webedit" Then
  			Set obsFld=CME_application.WebEdit(objDesc)
  		End If
  		
  		dynVal = ""
	  	If obsFld.Exist(20) Then
	  		
			dynVal=obsFld.GetROProperty("value")
	  		Call CaptureScreen("")
	    	CME_ReportScreenshot(i)
		Else 
			scrnShotTitle="TextField_NotFound"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1			
		End If
		
		call CME_FetchValueToGlobalVariable(value, dynVal)
		
		Set obsFld=Nothing


'********************************************************************
'Case name: CME_OBS_VerifyFieldValue
'Description: fetches field value in OBS screen
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	   

Case "CME_OBS_VerifyFieldValue"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	
  		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
  		
  		arrArgs = split(Win_Title_Field, "||")
  		clsNme = arrArgs(0)
  		prop = arrArgs(1)
  		If Trim(LCase(clsNme)) = "weblist" Then
  			Set obsFld=CME_application.WebList(objDesc)
  		ElseIf Trim(LCase(clsNme)) = "webedit" Then
  			Set obsFld=CME_application.WebEdit(objDesc)
  		ElseIf Trim(LCase(clsNme)) = "webelement" Then
  			Set obsFld=CME_application.WebElement(objDesc)
  		ElseIf Trim(LCase(clsNme)) = "webcheckbox" Then
  			Set obsFld=CME_application.WebCheckBox(objDesc)
  		End If
  		
	  	If obsFld.Exist(20) Then
	  		'obsFld.Highlight
	  		If IsDate(value) = True Then
				value = mmddyyyy(value)
			End If
			strFieldval=obsFld.GetROProperty(prop)
			
	  		If ucase(trim(value))=ucase(trim(strFieldval)) OR instr(ucase(trim(strFieldval)), ucase(trim(value)))>0 Then
                ReportPassed(i)
            Else
				scrnShotTitle="Value_Not_Matched"
				Call CaptureScreen(scrnShotTitle)
				CME_ReportFailed(i)
				CME_resFailed=CME_resFailed+1	
				
			End If
		Else 
			scrnShotTitle="Field_NotFound"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1			
		End If
		
		call CME_FetchValueToGlobalVariable(value, dynVal)
		
		Set obsFld=Nothing



'********************************************************************
'Case name: CME_OBS_GetValueFromTable
'Description:Fetches value from OBS tables
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020
'Description: Win_Title_Field = Table logical name || Column Name where value is fetched
			 'field = different cell value to identify row number dynamically
			 'value = variable name for fetched value
'*********************************************************************	    
	Case "CME_OBS_GetValueFromTable"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1   
		On error resume next
		ArrParms = Split(Win_Title_Field, "||")
		colName = ArrParms(1)
		Arg=ArrParms(0)
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set objTbl = CME_application.WebTable(objDesc)
		cellVal = ""
		If objTbl.Exist(20) Then
			'Getting Column count of the table
			colCount = objTbl.ColumnCount(1)
			colNum = ""
			If colCount <> 0 Then
				'Identifying Column number by column name"
				For iCol = 1 to colCount
				   curColumn =objTbl.GetCellData (1, iCol)  
					If ucase(trim(colName)) = ucase(trim(curColumn)) Then
					   colNum = iCol
					   Exit for
					   
			        End if
				Next
				rowNum = objTbl.GetRowWithCellText(field)
				If colNum <> "" Then
					cellVal = objTbl.GetCellData(rowNum, colNum)
					Call CaptureScreen("")
			    	CME_ReportScreenshot(i)
				Else 
					scrnShotTitle = "Column_NOT_Found"
					field = colName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
				End If
				
				'Writing the fetched value to global file
				'Call CME_FetchValueToGlobalVariable(value, cellVal)
			Else 
				'When Column count is 0
				Set objRow = objTbl.WebElement("html tag:=TD","innertext:=" & field,"visible:=true").Object.parentElement
				rowNum = objRow.rowIndex
				'Identifying Column number by Column name position in DOM
				If objTbl.WebElement("html tag:=TH","innertext:=" & colName,"visible:=true").Exist(5) Then
					colNum = objTbl.WebElement("html tag:=TH","innertext:=" & colName,"visible:=true").GetROProperty("attribute/data-column-index")
					'Fetching value in the table
					'objTbl.WebElement("html tag:=TR","index:="&rowNum,"visible:=true").WebElement("html tag:=TD","index:="&colNum,"visible:=true").Highlight
					cellVal = objTbl.WebElement("html tag:=TR","index:="&rowNum,"visible:=true").WebElement("html tag:=TD","index:="&colNum,"visible:=true").GetROProperty("innertext")
					Call CaptureScreen("")
			    	CME_ReportScreenshot(i)
					'Writing the fetched value to global file
					'Call CME_FetchValueToGlobalVariable(value, cellVal)
				Else 
					
					scrnShotTitle = "Column_NOT_Found"
					field = colName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
				End If
				
			End If
			Call CME_FetchValueToGlobalVariable(value, cellVal)
			
		Else 
			scrnShotTitle = "Table_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 				
		End If

	
	Set objTbl = Nothing
	Set objDesc = Nothing
	
	'********************************************************************
'Case name: CME_OBS_VerifyValueFromTable
'Description: Verifies Value from table
'Created by : 
'Modified by and date: 09/28/2020

'*********************************************************************	    
	Case "CME_OBS_VerifyValueFromTable"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1   
		On error resume next
		ArrParms = Split(Win_Title_Field, "||")
		colName = ArrParms(1)
		Arg=ArrParms(0)
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set objTbl = CME_application.WebTable(objDesc)
		cellVal = ""
		If objTbl.Exist(20) Then
			'Getting Column count of the table
			colCount = objTbl.ColumnCount(1)
			colNum = ""
			If colCount <> 0 Then
				'Identifying Column number by column name"
				For iCol = 1 to colCount
				   curColumn =objTbl.GetCellData (1, iCol)  
					If ucase(trim(colName)) = ucase(trim(curColumn)) Then
					   colNum = iCol
					   Exit for
					   
			        End if
				Next
				rowNum = objTbl.GetRowWithCellText(field)
				If colNum <> "" Then
					cellVal = objTbl.GetCellData(rowNum, colNum)
								
					If Trim(LCase(cellVal)) = Trim(LCase(value)) OR instr(1, ucase(trim(cellVal)), ucase(trim(value)))>0 Then
						ReportPassed(i)
					End If					
					
				Else 
					scrnShotTitle = "Column_NOT_Found"
					field = colName
					Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
				End If
				
				
				
		Else 
			scrnShotTitle = "Table_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 				
		End If
  End If
	
	Set objTbl = Nothing
	Set objDesc = Nothing
	'********************************************************************
'Case name: CME_AngJS_GetValueFromTable
'Description:Fetches value from OBS tables
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020
'Description: Win_Title_Field = Table logical name || Column Name where value is fetched
			 'field = different cell value to identify row number dynamically
			 'value = variable name for fetched value
'*********************************************************************	    
	Case "CME_AngJS_GetValueFromTable"
		Keyword = True
		CME_TS_Executed=CME_TS_Executed+1   
		On error resume next
		ArrParms = Split(Win_Title_Field, "||")
		colName = ArrParms(1)
		Arg=ArrParms(0)
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set objTbl = CME_application.WebElement(objDesc).WebTable("html tag:=Table","visible:=True")
		cellVal = ""
		If objTbl.Exist(20) Then
			'Getting Column count of the table
			colCount = objTbl.ColumnCount(1)
			'Identifying Column number by column name
			For iCol = 1 to colCount
			   curColumn =objTbl.GetCellData (1, iCol)  
				If ucase(trim(colName)) = ucase(trim(curColumn)) Then
				   colNum = iCol
				   Exit for
				   
		        End if
			Next
			rowNum = objTbl.GetRowWithCellText(field)
			cellVal = objTbl.GetCellData(rowNum, colNum)
			'msgbox cellVal
			Call CaptureScreen("")
	    	CME_ReportScreenshot(i)
			'Writing the fetched value to global file
			'Call CME_FetchValueToGlobalVariable(value, cellVal)
			
			Call CME_FetchValueToGlobalVariable(value, cellVal)
			
		Else 
			scrnShotTitle = "Table_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 				
		End If

	
	Set objTbl = Nothing
	Set objDesc = Nothing
	
	
	
'********************************************************************
'Case name: CME_OBS_ClkValueInTable
'Description: Clicks links in OBS screens
'Created by : Muzaffar A.
'Modified by and date: 04/19/2020

'*********************************************************************	    
	Case "CME_OBS_ClkValueInTable"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1   
		On error resume next
		ArrParms = Split(Win_Title_Field, "||")
		colName = ArrParms(1)
		Arg=ArrParms(0)
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=") 
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If 
		Next
		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set objTbl = CME_application.WebTable(objDesc)
		If objTbl.Exist(20) Then
			'Identifying row number by cell value
			Set objRow = objTbl.WebElement("html tag:=TD","innertext:=" & field,"visible:=true").Object.parentElement
			rowNum = objRow.rowIndex
			'Identifying Column number by Column name position in DOM
			colNum = objTbl.WebElement("html tag:=TH","innertext:=" & colName,"visible:=true").GetROProperty("attribute/data-column-index")
			'Clickingvalue in the tabel
			objTbl.WebElement("html tag:=TR","index:="&rowNum,"visible:=true").WebElement("html tag:=TD","index:="&colNum,"visible:=true").Click
			
		Else 
			scrnShotTitle = "Table_NOT_Found"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 				
		End If


	Set objTbl = Nothing
	Set objDesc = Nothing

	
	
'********************************************************************
'Case name: CME_OBS_SelectFromList
'Description: Selects value from weblists in OBS screen
'Created by : Muzaffar A.
'Modified by and date: 08/19/2020

'*********************************************************************	   

Case "CME_OBS_SelectFromList"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next
	  	
  		Arg=field
		propVal=CME_Value_from_Repository(Arg,"Value")
		propValArr=split(propVal, "||") 'Splitting property values fetched from OR
		Set objDesc = Description.Create 'Creating description for the object
		For iProp = 0 To UBound(propValArr) 
			arr = split(propValArr(iProp),":=")  
			If arr(1) <> "" Then 
				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
			End If				
		Next
		objDesc("visible").Value=true 'Adding "visible:=true" property to collection of description
  		Set objLst = CME_application.WebList(objDesc)
		If objLst.Exist(20) Then
			objLst.Select value
		Else 
			scrnShotTitle="Weblist_NotFound"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			On error goto 0
			Call CME_ExitTest() 
		End If
	
	
	
'********************************************************************
'Case name: CME_OBS_VerifyLabel
'Description: Selects value from weblists in OBS screen
'Created by : Muzaffar A.
'Modified by and date: 08/19/2020

'*********************************************************************	   

Case "CME_OBS_VerifyLabel"
		Keyword = True
		'CME_TS_Executed=CME_TS_Executed+1
	  	BoolfieldExist=False
	  	On error resume next	
		
		If Win_Title_Field = "" Then
			Win_Title_Field = "badge badge-primary"
		
		End If
		
		If value = "" Then
			indx = 0
		else
			indx = value
		End If
		Set obsLbl = CME_application.WebElement("class:=" & Win_Title_Field, "innertext:=" & field, "visible:=true", "index:=" & indx)
		If obsLbl.Exist(30) Then
			Call CaptureScreen("")
	    	CME_ReportScreenshot(i)
		Else 
			scrnShotTitle="label_NotFound"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
		End If
	
	Set obsLbl = Nothing

'********************************************************************
'Case name: CME_VerifyRQSMsg
'Description: Verifying Value from Rate Quote App
'Created by : Vaishnavi
'Modified by and date: 03/18/2021

'*********************************************************************
		Case "CME_VerifyRQSMsg"        
    	Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next		

		Set VerMsg = CME_RateQuote.WebElement("html tag:=SPAN","innertext:=Approved","Visible:=True") '
		
		If VerMsg.Exist(30) Then
'		msgbox "hi"
	    	scrnShotTitle = "RQSApproved"
	    	Call CaptureScreen(scrnShotTitle)
	    	CME_ReportScreenshot(i)
	    	
	    Else 
			scrnShotTitle="RQSFailed"
'			msgbox "fail"
			Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)	
			
			Call CME_ExitTest()
						
	    End If
	   
			
		Set VerMsg = Nothing
		


'********************************************************************
'Case name: CME_RateQuote_SelectFromList
'Description: Selecting drop down values from Rate Quote App
'Created by : Shruthi
'Modified by and date: 03/04/2021
'Win_Title_Field= OR .
'value=Dropdown value to be selected
'*********************************************************************
Case "CME_RateQuote_SelectFromList" 
		Keyword = True
        CME_TS_Executed=CME_TS_Executed+1
        BoolfieldExist=False
        On error resume next
'		Arg=Win_Title_Field
'	   	propVal=CME_Value_from_Repository(Arg,"Value")
'	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
'		Set objDesc = Description.Create 'Creating description for the object
'		For iProp = 0 To UBound(propValArr) 
'			arr = split(propValArr(iProp),":=") 
'			If arr(1) <> "" Then 
'				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
'			End If 
'		Next
'		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description

    	Set listbox=CME_RateQuote.WebList("attribute/name:="&field&".*","class:=.*form-control.*","index:=0","Visible:=True")
    	If listbox.Exist(10)=True Then
    		listbox.Select value
    		Reporter.ReportHtmlEvent micPass, Win_Title_Field & field,testdescription&"( Step.No" & i+1 & " )"
		Else 
			scrnShotTitle="ListBox_Not_Found"
		    Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			
			On error goto 0
			Call CME_ExitTest()
		End If
		Set listbox=nothing
		Set objDesc=Nothing


'********************************************************************
'Case name: CME_RateQuote_EnterSpread
'Description: For entering  the  Association spread in Rate Quote App
'Created by : Shruthi
'Modified by and date: 03/04/2021
'Win_Title_Field= OR .
'value=Dropdown value to be selected
'*********************************************************************
Case "CME_RateQuote_EnterSpread" 

		Keyword = True
        CME_TS_Executed=CME_TS_Executed+1
        BoolfieldExist=False
        On error resume next
'		Arg=Win_Title_Field
'	   	propVal=CME_Value_from_Repository(Arg,"Value")
'	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
'		Set objDesc = Description.Create 'Creating description for the object
'		For iProp = 0 To UBound(propValArr) 
'			arr = split(propValArr(iProp),":=") 
'			If arr(1) <> "" Then 
'				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
'			End If 
'		Next
'		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description
		Set textField=CME_RateQuote.WebNumber("attribute/name:="&field&".*","class:=form-control.*","index:=0","Visible:=True")
		If textField.Exist(10)=true Then
			textField.Set value
			'ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	   	    
		Set textField=nothing
		Set objDesc=Nothing 
		


Case "CME_RateQuote_Btn"
Keyword = True
	    'CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    Call CME_RateQuote_Btn(value)
	    
	    
'********************************************************************
'Case name: CME_RateQuote_EnterText
'Description: For entering  the values in Rate Quote App
'Created by : Vaishnavi
'Modified by and date: 03/04/2021
'Win_Title_Field= OR .
'value=Dropdown value to be selected
'*********************************************************************
		
		
		Case "CME_RateQuote_EnterText"     
	    Keyword = True
	    'CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    If value="" Then
	    	CME_EnterTextReportFailed(i)
	    	CME_resFailed=CME_resFailed+1
	    	'CME_FetchResultStatusAndEnterinFinalResults(resPath)
	    	On error goto 0
	    	Call CME_ExitTest()
	    End If
'	    Arg=field
'	    propVal=CME_Value_from_Repository(Arg,"Value")
'	    propValArr=split(propVal, "||") 'Splitting property values fetched from OR
'		Set objDesc = Description.Create 'Creating description for the object
'		For iProp = 0 To UBound(propValArr) 
'			arr = split(propValArr(iProp),":=") 
'			If arr(1) <> "" Then 
'				objDesc(arr(0)).Value = arr(1) 'Generates dynamic description collection based on the properties from the OR
'			End If 
'		Next
'		objDesc("visible").Value=True 'Adding "Visible:=True" property to collection of description

    	Set textField=CME_RateQuote.WebEdit("attribute/name:="&field&".*","class:=form-control.*","index:=0","Visible:=True")
    ''	Set textField=CME_RateQuote.WebEdit("html id:="&field,"class:=form-control.*","index:=0","visible:=True")
 
		If textField.Exist(10)=true Then
			
			textField.Set value
			'ReportPassed(i)
    		''CME_resPassed='CME_resPassed+1
    		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
	   End If
	   	    
		Set textField=nothing
		Set objDesc=Nothing
	


Case "CME_Launch_CFC_RateQuote"        
    	Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next
	    
	     'envURL = "FBL"&envURL
        Select Case  Trim(UCase(envURL))
		Case "FBLINTTST" 
	    	strURL = "https://wholesalerates-inttst.farmcreditbank.com/"
	    Case "FBLDATO" 	
	    	strURL = "https://wholesalerates-dato.farmcreditbank.com/"
	    Case "FBLRSTG" 
	    	strURL = "https://wholesalerates-inttst.farmcreditbank.com/"	
	    Case "FBLTRAIN" 
	    	strURL = "https://wholesalerates-datx.farmcreditbank.com/"
	    
		End Select 
    	SystemUtil.Run "iexplore.exe", strURL ,,,3
'SystemUtil.Run "chrome.exe", strURL ,,,3

		CME_RateQuote.Sync 
		
Case "CME_RQSWait"        
    	Keyword = True
	    CME_TS_Executed=CME_TS_Executed+1
	    BoolfieldExist=False
	    On error resume next		

		Set objWait = CME_RateQuote.WebElement("html id:=BlockUI","Visible:=True")
		
		
		Do while  objWait.Exist(1)
		'Do nothing
			wait 1	
		Loop		       
	    set objWait=nothing
	    
Case  "CME_RQSEnterDynamicVal"		
		   	Keyword = True
	   	 	CME_TS_Executed=CME_TS_Executed+1
	    	BoolfieldExist=False
	    	On error resume next
	    	
	    	dynamicVal=CME_FetchValueFromGlobalVariable(value)
	    	 
		    Set textField=CME_RateQuote.WebEdit("attribute/name:="&field&".*","class:=form-control.*","index:=0","Visible:=True")
			
		If textField.Exist(10)=true then
			textField.Click
			textField.Set dynamicVal
			ReportPassed(i)
    		'CME_resPassed='CME_resPassed+1
	    Else 
	   		scrnShotTitle="TxtField_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
			On error goto 0
			Call CME_ExitTest() 
	   End If
			    
	   Set textField=nothing

'************************* End of CME keywords ******************************************

		
				
			                		
		 End Select
		if Keyword = False  Then
       		 Msgbox "Error in KeyWord in the row" & i+1 
    	End if
	'End if 
  Next 
   'DeleteSheet(respath) 
UpdateResultSheet(resPath) 
  
End Function 



'//End of BaseScript Function"//

'********************************************************************
'Case name: CME_RateQuote_Btn
'Description: For Clicking buttons in Rate Quote App
'Created by : Vaishnavi
'Modified by and date: 03/04/2021
'Win_Title_Field= OR .
'value=Dropdown value to be selected
'*********************************************************************

Function CME_RateQuote_Btn(btnName)
	
	If index<>"" Then
    		indx = index
    	Else 
    		indx = 0
    	End If
'    	Msgbox btnName
    		Set button=CME_RateQuote.WebButton("innertext:=.*"&btnName&".*","visible:=true")
	  
	    BoolfieldExist=button.Exist(30)
	    
	    If BoolfieldExist=True Then
'	    Msgbox "Entered"
	    	'wait(5)
	    	'//Checking if button is enabled
	    	
				button.click

	    	
		    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		Else 
			scrnShotTitle=field &"_Button_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
		End If
		Set button=nothing
	
End Function

'****************************************************************************************************************************
'Function	: UpdateResultSheet
'Description	: This  function updates settings of the Low Level Result Sheet
'****************************************************************************************************************************
Function UpdateResultSheet(resPath)
	Dim sheetNameArray(1)
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set WorkSheets = objWorkbook.WorkSheets
			 
				
	rowcount =  WorkSheets(1).UsedRange.Rows.Count
	
	for p = 5 to rowcount
		   
		if ( WorkSheets(1).cells(p,3)) = "Passed" then
			pass1 = pass1+1
		End if
		if ( WorkSheets(1).cells(p,3)) = "Failed" then
			fail1= fail1+1
		End if
	next
	
	
	
	WorkSheets(1).cells(5,5).Value = pass1
	WorkSheets(1).cells(5,6).Value = fail1
	objWorkbook.save
	
	For i=1 to  WorkSheets.count
			sheetNameArray(i-1)=WorkSheets(i).name
	Next
	
	objExcel.DisplayAlerts = False   
	For j=0 to ubound(sheetNameArray)
		 If sheetNameArray(j)<>"LowLevelResultSheet" Then
		 	If  sheetNameArray(j)<>"" Then
			 	objWorkbook.sheets(sheetNameArray(j)).Delete
			End If
		 End If
	Next

	'WorkSheets(1).Range("A:F").Font.Name = "Arial"
	WorkSheets(1).Columns("A:G").EntireColumn.AutoFit
	WorkSheets(1).Cells.WrapText =true
	objWorkbook.save
	objExcel.DisplayAlerts = True 
	objWorkbook.Application.Quit
	Set objWorkbook = Nothing

End Function

'****************************************************************************************************************************
'Function	: TestCaseCount
'Description	: This  function returns the total Testcase Count
'****************************************************************************************************************************
Function TestCaseCount( Datafile_Path)

'//** Added Code for CME Application by Evry Automation Team  
If Suite="CME_Automation" Then
    Set objExcel=Createobject("Excel.Application")
    Set objWb=objExcel.Workbooks.Open(Datafile_Path)
    Set objSheet=objWb.Worksheets(1)
    intTotalRowsCount=objSheet.usedrange.rows.count
'    For row = 2 To intTotalRowsCount
'        strCommands=objSheet.cells(row,1).value
'    	strCommands=ucase(trim(strCommands))
'        If strCommands=ucase(trim("CME_LoadGUIProperty")) or strCommands=ucase(trim("CME_ECMUpload_New")) or strCommands=ucase(trim("CME_Delete_ECMdoc")) or strCommands=ucase(trim("CME_EnterText")) or strCommands=ucase(trim("Cme_Clkbtn")) or strCommands=ucase(trim("CME_VerifyScreen")) or strCommands=ucase(trim("CME_SelectFromList")) or  strCommands=ucase(trim("CME_SelectRadioBtn")) or  strCommands=ucase(trim("CME_ClkMenuItem")) or  strCommands=ucase(trim("CME_VerifyLogin")) or strCommands=ucase(trim("CME_InfoPopup")) or  strCommands=ucase(trim("CME_HandleCsiPopUps")) or strCommands=ucase(trim("CME_DDTScreen")) or strCommands=ucase(trim("CME_VerifyFieldVal")) or strCommands=ucase(trim("CME_Verify_Edit")) or strCommands=ucase(trim("CME_Verify_Element")) or strCommands=ucase(trim("CME_GetDealNumAndSearch")) or strCommands=ucase(trim("CME_Searchdeal")) or strCommands=ucase(trim("CME_SendKeys")) or strCommands=ucase(trim("CME_Verify_NoInsight")) or strCommands=ucase(trim("CME_Verify_Insight")) or strCommands=ucase(trim("CME_ClickExistingDeal"))  or strCommands=ucase(trim("CME_ClickCoBorrower_Grantor_Gaurantor"))  or strCommands=ucase(trim("CME_ClkImage")) or strCommands=ucase(trim("CME_Wait")) or strCommands=ucase(trim("CME_ClkLink")) or strCommands=ucase(trim(" CME_VerifyDeletedRelatedEntity")) or strCommands=ucase(trim("CME_Refresh")) or strCommands=ucase(trim("CME_SendKeys_ECM")) or strCommands=ucase(trim("CME_ECMUpload_Browse")) or strCommands=ucase(trim("CME_ECMUpload_Browse2")) or strCommands=ucase(trim("CME_ECMUpload_Browse3")) or strCommands=ucase(trim("CME_SendKeys_Facilities")) or strCommands=ucase(trim("CME_ClickLastDealNum")) or strCommands=ucase(trim("CME_WaitForObject")) or strCommands=ucase(trim("CME_ClickEditbtn")) or strCommands=ucase(trim("CME_SendKeys_EvaluationType")) or strCommands=ucase(trim("CME_CloseLatestOpenedBrowser"))then
'            count=count+1
'        End If 
'    Next
CME_TestStepCount=intTotalRowsCount-1

objExcel.Quit
Set objExcel=nothing
Set objWb=nothing
Set objSheet=nothing

else
'//** End of Added Code for CME Application by Evry Automation Team  
Dim  cnn,rs, countquery,Num

' Create Connection Object
	Set cnn = CreateObject("ADODB.Connection") 
	P = split( Datafile_Path,"\")
	For k=0 to  Ubound(P)-1
		If k=0 Then
		  Datafile_Dir=P(k)
		  'Msgbox Datafile_Dir
		else
	  Datafile_Dir=Datafile_Dir& "\"&P(k)
	  Msgbox Datafile_Dir
end if
	Next	
	Set rs = CreateObject("ADODB.Recordset") 
	cnn.ConnectionString ="Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=H:\CME_Automation\DataFile\Screen\Login_Csearch.xlsx;ReadOnly=1; Extended Properties='IMEX=1'"
	'msgbox cnn.State
	cnn.Open 

countquery="Select count(*) from Csearch where Commands IN ('LOADGUIProperty','LoadWindowProperty','Warning','Question','VerifyButtonExit','VerifyText','EnterNVerifyText','VerifyLabel','VerifyComposite','VerifyCompositeExit','VerifyCombo','VerifyWindowText','VerifyMultiComposite','VerifyMultiCompositeExit','VerifyMultiCompositeTolerance','VerifyMultiCompositeToleranceExit','VerifyTextTolerance')"
rs.Open  countquery,cnn
Num =0
 
var =  rs.Fields(0).Name
Num =  rs(var).Value
rs. close
'TestCaseCount=Num
End  if
End Function

'****************************************************************************************************************************
'Function 	:TimeElapsed
'Description	:to calculate the elapsed time since start of execution
'****************************************************************************************************************************

Function TimeElapsed(starttime)
hour1=hour(starttime)
min1=minute(starttime)
sec1=second(starttime)
currenttime=time
hour2=hour(currenttime)
min2=minute(currenttime)
sec2=second(currenttime)
min2=minute(currenttime)
sec2=second(currenttime)
If sec2<sec1 Then
	sec2=sec2+60
    min2=min2-1
    finalsec=sec2-sec1
else
      finalsec=sec2-sec1
end if

If (min2<min1) then 
	min2=min2+60
	finalmin=min2-min1
	hour2=hour2-1
	else
	finalmin=min2-min1
End If
If hour2<hour1 Then
   finalhour=hour2+(24-hour1)
  else
   finalhour=hour2-hour1
end if
TimeElapsed=finalhour&":"&finalmin&":"&finalsec
End Function

'************************************************************************************************
'Function name: CME_TestResults 
'Description: Function which writes the status of execution to an intermediate file for CME Tests
'Created by : Automation Team
'Modified by and date:
'*************************************************************************************************

'Function CME_TestResults()
'
'Dim fso, MyFile, fpath
'	CME_TestStepCount=datatable.GetRowCount
'	fpath="H:\CME_Automation\RESULTS\IntermediateResult.txt"
'	rString = "Test Case ID = " & CME_TC_ID & ",Total Test Steps = " & CME_TestStepCount & ",Executed = " & CME_TS_Executed & ",Passed = "& 'CME_resPassed & ",Failed = "& CME_resFailed & ",Test Duration = " & TimeElapsed(starttime)
'    rString=split(rString, ",")
'   Set fso = CreateObject("Scripting.FileSystemObject")
'   flag=fso.FileExists(fpath)
'   If flag=true Then
'   		Set file=fso.OpenTextFile(fpath, 2)
'   		
'   		For each item in rString
'   			file.WriteLine(item)
'   		Next
'   		file.Close
'   Else 
'   		Set file=fso.CreateTextFile("H:\CME_Automation\RESULTS\IntermediateResult.txt", true)
'   		For each item in rString
'   			file.WriteLine(item)
'   		Next
'   		file.Close
'   End If
'Set file=nothing
'Set fso=nothing
'
'End Function
'
'****************************************************************************************************************************
'Function	:ResultStatus
'Description	:Funtion which writes the status of execution to an intermediate file.
'****************************************************************************************************************************

Function ResultStatus(TTC,TTE,TTP,TTF,Starttime)
   Status = window("text:=Form1").Exist(2)
   'Duration = Round((Time - Starttime)*1000,4)
'Duration=Round((abs(DateDiff("s",now,Starttime))/60),2)
Duration=TimeElapsed(Starttime)
   Const ForReading = 1, ForWriting = 2
   Dim fso, f
   

   'To Get the System name
	
   Set WshShell = CreateObject("WScript.Shell")
   Set WshSysEnv = WshShell.Environment("PROCESS")
   'ret= WshSysEnv("HOMEPATH")
  ' arr = split(ret,"\")
   'sLen = Ubound(arr)
   'HostName = arr(sLen)

  rString = "TotalTestSteps =" &TTC & ",Executed=" & TTE & ",Passed="& TTP & ",Failed="& TTF &",Duration="  & Duration &"  Minutes"&", SDATE=" & Starttime &",EDATE= In Progress" & ",LDATE=" &  now   
   
  
  Set fso = CreateObject("Scripting.FileSystemObject")
'/*Start  of Modified part for Centralized Library by MKT-S
Select Case  Suite
					Case "SmokeTest"
								fpath="H:\SmokeTest\RESULTS\IntermediateResult.txt"
					Case "DLC" 
								fpath="H:\DLC\RESULTS\IntermediateResult.txt"
					Case "E2E" 
								fpath="H:\E2E\RESULTS\IntermediateResult.txt"
					Case "CME_Automation"    '//** Added Case for CME Application by Evry Automation Team  
								fpath="H:\CME_Automation\RESULTS\IntermediateResult.txt"
								TotalTestSteps=DataTable.GetRowCount-1
								rString = "TotalTestSteps = " & TotalTestSteps & ",Executed = " & Tcs_Executed & ",Passed = "& resPassed & ",Failed = "& resFailed & "Test Duration = "& TimeElapsed(starttime) &",Time = " & now  
								
End Select

'/*End  of Modified part for Centralized Library by MKT-S

  rString=split(rString, ",")
  flg=fso.FileExists(fpath)

	If flg Then
		Set floc= fso.OpenTextFile(fpath, 2)
		
		For each item in rString
			floc.WriteLine(item)
		Next
		
		floc.Close
	Else
		Set floc = fso.CreateTextFile(fpath,true)
		For each item in rString
			floc.WriteLine(item)
		Next
		floc.Close
	End If


   if (Status = False) then		
   End if
ResultStatus = Tru

End Function

'****************************************************************************************************************************
'Funtion 	:Create_Object
'Description 	:Creates an Object and returns the same
'****************************************************************************************************************************
Function Create_Object(Object_Pro)
   Prop_Val = Split(Object_Pro,"|")
   Set Obj_Name = Description.Create 
		For i = 0 To UBound(Prop_Val)  
			arr_1 = split(Prop_Val(i),"=") 
			If arr_1(1) <> "" Then 
				Obj_Name(arr_1(0)).Value = arr_1(1) 
			End If 
		Next 

  set Create_Object = Obj_Name
		
 End Function

'****************************************************************************************************************************
'Function 	: Values_form_Steptable 
'Description	: Function to create a DSN and fetch the properties from a object_repository file
'****************************************************************************************************************************

Function Values_form_Steptable (Win_Field) 
	On Error Resume Next 
	Dim  cnn,rs,qry,proObj 
	Arg = split(Win_Field,"|") 
	If (Err.Description <> "") Then 
		'MsgBox Err.Description 
	End If 
	
	' Create Connection Object
	Set cnn = CreateObject("ADODB.Connection") 
	P = split(PROP_Path,"\")
	For k=0 to  Ubound(P)-1
		If k=0 Then
			Default_Dir=P(k)
		else	
		Default_Dir=Default_Dir& "\"&P(k)
		end if
	Next	
	
	cnn.ConnectionString =  "Driver={Microsoft Excel Driver (*.xls, *.xlsx, *.xlsm, *.xlsb)};DBQ=" & PROP_Path & ";ReadOnly=0; Extended Properties='IMEX=1'"
	cnn.Open 
	If (Err.Description <> "") Then 
		'MsgBox Err.Description 
		Err.Clear 
		ExitAction() 
	End If 
	' Create RecordSet Object 
	Set rs = CreateObject("ADODB.Recordset") 
	qry = "Select ObjectProperties from Object_repository where LogicalName='" & Arg(0) & "' And WindowName='" & Arg(1) & "'" 
	rs.Open qry,cnn,3,3 
	If (Err.Description <> "") Then 
		'MsgBox Err.Description 
		'Err.Clear
	End If 
	
	For J = 0 To rs.RecordCount  
		proObj = rs("ObjectProperties") 
	
	If (Err.Description <> "") Then 
			'MsgBox Err.Description 
			Err.Clear 
		End If 
	Next 

	Values_form_Steptable = proObj 
End Function 

'****************************************************************************************************************************
'Function	:GetCount 
'Description	:Returns the size of the array
'****************************************************************************************************************************'
Function GetCount (arr)
On Error Resume Next
len1 = 0
Do
If arr(len1)="" Then
GetCount = len1
Exit Function
End If
Txt1 = arr(len1)
len1 = len1+1
Loop While CStr(Err.Number)="0"
Err.Clear
GetCount = len1-1
End Function


'****************************************************************************************************************************
''Function	:AddDelimeter 
'Description	Adding delimeter to tabs
'****************************************************************************************************************************'
Function AddDelimeter(tabRec)
Dim RemStr
RemStr=""
Flag=false
for SInd=1 to len(tabRec)
	if Asc(mid(tabRec,SInd,2))= "9" then ' Updated as part of LIQ Java Version
		RemStr=RemStr &"|"& mid(tabRec,SInd,2)
		SInd=SInd+2
		while  mid(tabRec,SInd,1)=" "
			SInd=SInd+1
		wend
	end if
	RemStr=RemStr & mid(tabRec,SInd,1)
next
AddDelimeter=RemStr
End Function

'****************************************************************************************************************************
'Function	:ReportPassed 
'Description :Update excel with passed value
'****************************************************************************************************************************'


Function ReportPassed(i)
 Reporter.ReportEvent 0,Field,testdescription & "| Step.No" & i+1 & " |"
 resPassed=resPassed+1		

Set objExcel = CreateObject("Excel.Application")
objExcel.visible = False
Set objWorkbook = objExcel.Workbooks.Open(resPath)
Set objWorksheet = objWorkbook.Worksheets(1)


Dim val
val = objWorksheet.UsedRange.Rows.Count
val =val+1

resPassedVerify=resPassedVerify+1
testdescription=replace(testdescription, "|", "_")
objWorksheet.Cells(val,1) = field
objWorksheet.Cells(val,2) = testdescription & "| Step.No" & i+1 & " |"
objWorksheet.Cells(val,3) ="Passed"
objWorksheet.Cells(val,4) = now()


'msgbox resPassedVerify

'objWorksheet.Cells(5,5) = resPassedVerify
'objWorksheet.Cells(5,6) = resFailedVerify
'
'

'objWorksheet.Columns("A:G").EntireColumn.AutoFit	
objWorkbook.save
objWorkbook.Close 
'objWorkbook.Application.Quit
'objWorkbook.Close(True)

Set objWorksheet = Nothing
Set objWorkbook = Nothing

objExcel.Quit
Set objExcel = Nothing



End Function



'****************************************************************************************************************************
'Function	:CME_ReportScreenshot 
'Description :Update excel with passed value
'****************************************************************************************************************************'


Function CME_ReportScreenshot(i)
 Reporter.ReportEvent 0,Field,testdescription & "| Step.No" & i+1 & " |"
 resPassed=resPassed+1		

Set objExcel = CreateObject("Excel.Application")
objExcel.visible = False
Set objWorkbook = objExcel.Workbooks.Open(resPath)
Set objWorksheet = objWorkbook.Worksheets(1)
'msgbox objWorksheet.Cells(5,5)
Dim val
val = objWorksheet.UsedRange.Rows.Count
val =val+1

resPassedVerify=resPassedVerify+1
testdescription=replace(testdescription, "|", "_")
objWorksheet.Cells(val,1) = field
objWorksheet.Cells(val,2) = testdescription & "| Step.No" & i+1 & " |"
objWorksheet.Cells(val,3) ="Passed"
objWorksheet.Cells(val,4) = now()	
objWorksheet.Cells(val,7) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
'msgbox resPassedVerify



objWorksheet.Columns("A:G").EntireColumn.AutoFit	
objWorkbook.save
'objWorkbook.Application.Quit
objWorkbook.Close(True)

Set objWorksheet = Nothing
Set objWorkbook = Nothing

objExcel.Quit
Set objExcel = Nothing
End Function


'****************************************************************************************************************************
'Function	:CME_ReportLoadTime 
'Description :Update excel with passed value
'****************************************************************************************************************************'


Function CME_ReportLoadTime(i, elpTm)
 Reporter.ReportEvent 0,Field,testdescription & "| Step.No" & i+1 & " |"
 resPassed=resPassed+1		

Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(resPath)
Set objWorksheet = objWorkbook.Worksheets(1)
'msgbox objWorksheet.Cells(5,5)
Dim val
val = objWorksheet.UsedRange.Rows.Count
val =val+1

resPassedVerify=resPassedVerify+1
testdescription=replace(testdescription, "|", "_")
objWorksheet.Cells(val,1) = Commands
objWorksheet.Cells(val,2) = "Loading " &field & "| Step.No" & i+1 & " |"
objWorksheet.Cells(val,3) ="Passed"
objWorksheet.Cells(val,4) = now()	
objWorksheet.Cells(val,8) = "Load Time: " & elpTm & " Seconds"
objWorksheet.Cells(val,8).Interior.ColorIndex = "6"
'msgbox resPassedVerify


'objWorksheet.Columns("A:G").EntireColumn.AutoFit	
objWorksheet.UsedRange.Columns.EntireColumn.AutoFit
objWorkbook.save
'objWorkbook.Application.Quit
objWorkbook.Close(True)

Set objWorksheet = Nothing
Set objWorkbook = Nothing

objExcel.Quit
Set objExcel = Nothing
End Function

'****************************************************************************************************************************
'Function	:ReportFailed 
'Description :Update excel with Failed value
'****************************************************************************************************************************'

Function ReportFailed(i)
		Reporter.ReportEvent 1,Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1

	   Set objExcel = CreateObject("Excel.Application")
Set objWorkbook = objExcel.Workbooks.Open(resPath)
Set objWorksheet = objWorkbook.Worksheets(1)

resFailedVerify=resFailedVerify+1
Dim val
val = objWorksheet.UsedRange.Rows.Count
val =val+1
objWorksheet.Cells(val,1) = field
objWorksheet.Cells(val,2) = testdescription & "| Step.No" & i+1 & " |"
objWorksheet.Cells(val,3) ="Failed"
objWorksheet.Cells(val,4) = now()	


		
objWorkbook.save
objWorkbook.Application.Quit

End Function

'****************************************************************************************************************************
'Function	:CreateResultFile 
'Description :Create and Update excel with results
'Modified By : EVRY Automation Team 
'***************************************************************************************************************************'

Function CreateResultFile()
respth=split(Path,"\")
Select Case  Suite
	
    '//** start of case for CME Application by Evry Automation Team
	Case "CME_Automation"
			resfolder1 = respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\RESULTS"
			resfolder2 = resfolder1 & "\"&respth(7)
			resfolder2 = resfolder2 & "\"&respth(8)
			resfolder3 = resfolder2 & "\"&environment.Value("EnvironmentName")
			'setting screenshot folder
			scrnShotFolder = resfolder3 & "\Screenshots"
			
			'setting CME-CSI folder
			CME_CSiFolder = resfolder3 & "\CME-CSi Results"
			
			
			'setting Result sheet path
			resPath = resfolder3 & "\" & respth(9)
		''	msgbox resPath
			strTitle = respth(9)
			
		
	Case "End_to_End_Automation_Scripts"    
			resfolder1=respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\RESULTS"
			resfolder2 = resfolder1
			resfolder3 = resfolder1
			scrnShotFolder = resfolder3
			resPath=respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\RESULTS\"&respth(8)
			strTitle= respth(8)
'							msgbox "resfolder1-"&resfolder1
'							msgbox "resPath-"&resPath
			'CME_ScrnShotFolder=strTitle
	'//** End of case for CME Application by Evry Automation Team
					
					
End Select

'Changing extension to .xlsx
	If Right(resPath,1)<>"x" Then
		resPath=resPath&"x"
	End If
	
'Create Result Folder

	Dim fso, f , fs
		   Set fso = CreateObject("Scripting.FileSystemObject")
		   ret1= fso.FolderExists(resfolder1)
		   If ret1  Then
		   	Else
		   	 fso.CreateFolder (resfolder1)
		   End If
		   
		   ret= fso.FolderExists(resfolder2)
		    If ret  Then
		   	Else
		   	 Set f = fso.CreateFolder(resfolder2)
		   End If
		   
		   ret2= fso.FolderExists(resfolder3)
		   If ret2 Then
		   	else
		   	Set f=fso.CreateFolder(resfolder3)
		   End If
		   'retsc=fso.FolderExists(sreenfolder)
 		   resfile = fso.fileexists(resPath)
	If  resfile Then
		fso.DeleteFile(resPath)
	End If
 	
 	If Not fso.FolderExists(scrnShotFolder) Then 
		scrnShotFolder = fso.CreateFolder(scrnShotFolder) 
	End If
 	
 	If Not fso.FolderExists(CME_CSiFolder) Then 
		CME_CSiFolder = fso.CreateFolder(CME_CSiFolder) 
	End If
 	
 	wait 2
 	
	
	
 	
 	'resfile = fso.fileexists(resPath)

	'If ret  Then
			
		'If resfile then

		'Else
			Set Excel = CreateObject ("Excel.Application")
			Set ExcelSheet = CreateObject ("Excel.Sheet")
			ExcelSheet.Application.Visible = False
  	
			Excelsheet.Worksheets.Add

			ExcelSheet.ActiveSheet.Name = "LowLevelResultSheet"
			ExcelSheet.ActiveSheet.Cells(4,1).Value = "Object"
			ExcelSheet.ActiveSheet.Cells(4,2).Value = "Description"
			ExcelSheet.ActiveSheet.Cells(4,3).Value = "Result Status"
			ExcelSheet.ActiveSheet.Cells(4,4).Value = "Time Stamp"
			
			ExcelSheet.ActiveSheet.Cells(4,5).Value = "Verifications Passed"
			ExcelSheet.ActiveSheet.Cells(4,6).Value = "Verification Failed"
			ExcelSheet.ActiveSheet.Cells(4,7).Value = "Screenshots"
			ExcelSheet.ActiveSheet.Cells(4,8).Value = "Screen Load Time"
			
			ExcelSheet.ActiveSheet.Range("A1:H1").Merge 
			ExcelSheet.ActiveSheet.Cells(1,1).Font.ColorIndex = 1
			ExcelSheet.ActiveSheet.Cells(1,1).Font.ColorIndex = 1
			ExcelSheet.ActiveSheet.Cells(1,1).Interior.ColorIndex="40"
	
'			If Right(strTitle,1)="x" Then     '//** Modified Code to Check Excel File Extension by Evry Automation Team
'				strTitle=strTitle
'			Else
'				strTitle= strTitle&"x"
'			End If
			ExcelSheet.ActiveSheet.Cells(1,1).value="Script Title :  "&strTitle
			ExcelSheet.ActiveSheet.Cells(1,1).Font.Bold=true
			ExcelSheet.ActiveSheet.Range("A4:H4").Font.Bold=true
			ExcelSheet.ActiveSheet.Range("A4:H4").Font.ColorIndex = 9
			ExcelSheet.ActiveSheet.Range("A4:H4").Interior.ColorIndex = 37
			ExcelSheet.ActiveSheet.Columns("A:H").EntireColumn.AutoFit
			
			
			
			ExcelSheet.SaveAs resPath

			ExcelSheet.Application.Quit
			Set ExcelSheet = Nothing

		
			
'	else
'			 Set f = fso.CreateFolder(resfolder)
'			
'			 Set Excel = CreateObject ("Excel.Application")
'			 Set ExcelSheet = CreateObject ("Excel.Sheet")
'             ExcelSheet.Application.Visible = False
'                                
'  			Excelsheet.Worksheets.Add
'
'			ExcelSheet.ActiveSheet.Name = "LowLevelResultSheet"
'			ExcelSheet.ActiveSheet.Cells(4,1).Value = "Object"
'			ExcelSheet.ActiveSheet.Cells(4,2).Value = "Description"
'			ExcelSheet.ActiveSheet.Cells(4,3).Value = "ResultStatus"
'			ExcelSheet.ActiveSheet.Cells(4,4).Value = "Time"
'
'			ExcelSheet.ActiveSheet.Cells(4,5).Value = "Total_number_of_Verification_Passed"
'			ExcelSheet.ActiveSheet.Cells(4,6).Value = "Total_number_of_Verification_Failed"
'
'
'			ExcelSheet.ActiveSheet.Range("A1:F1").Merge 
'			ExcelSheet.ActiveSheet.Cells(1,1).Font.ColorIndex = 1
'			ExcelSheet.ActiveSheet.Cells(1,1).Font.ColorIndex = 1
'			ExcelSheet.ActiveSheet.Cells(1,1).Interior.ColorIndex="40"
'		
'			ExcelSheet.ActiveSheet.Cells(1,1).value="Script Title :  "&strTitle
'			ExcelSheet.ActiveSheet.Cells(1,1).Font.Bold=true
'			ExcelSheet.ActiveSheet.Range("A4:F4").Font.Bold=true
'			ExcelSheet.ActiveSheet.Range("A4:F4").Font.ColorIndex = 9
'            If Right(respath,1)<>"x" Then
'				resPath=resPath&"x"
'			End If
'			ExcelSheet.SaveAs resPath
'			ExcelSheet.Application.Quit
'			Set ExcelSheet = Nothing
'
'
'    	 End If
'
	Set CreateResultFile = fso
End Function

'****************************************************************************************************************
'Function	: Excel_Create()
'Description	: Funtion to write the array values in to Excel File
'****************************************************************************************************************
Function Excel_Create()
'**************************************Create Reference to an Excel File*****************************************
set str = CreateObject("Excel.Application")

Select Case Suite
	Case "SmokeTest" ' Needs to Review in future
				str.Workbooks.Open "H:\SmokeTest\RESULTS\deal_saveas.xls"
	Case "DLC"
				str.Workbooks.Open "H:\DLC\RESULTS\deal_saveas.xls"
	Case "E2E"
				str.Workbooks.Open "H:\E2E\RESULTS\deal_saveas.xls"
End Select

'****************************************************************************************************************
for v = 1 to 100
if (deal_dynamic(v) <> "") then
dealin = split(deal_dynamic(v), "|")
str.ActiveWorkBook.Worksheets("Sheet1").Cells(upd,1) = dealin(0)
str.ActiveWorkBook.Worksheets("Sheet1").Cells(upd,2) = dealin(1)
upd = upd + 1
end if
next


for each dealin1 in deal_static
if (dealin1 <> "") then
dealin = split(dealin1, "|")
str.ActiveWorkBook.Worksheets("Sheet1").Cells(upd,1) = dealin(0)
str.ActiveWorkBook.Worksheets("Sheet1").Cells(upd,2) = dealin(1)
upd = upd + 1
end if
Next

'***************************************Closing the Excel File****************************************************
str.ActiveWorkBook.Save
str.ActiveWorkBook.Close
str.Application.Quit
'******************************************************************************************************************
End Function

'****************************************************************************************************************************
'Funtion 	:Win_Enter_In_A_TextBox 
'Description	:activates the appropriate window and enters the text in the specified edit box.'
'****************************************************************************************************************************

Function Win_Enter_In_A_TextBox (Win_Obj_Pro_Val) 
	On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next
	'Added this to handle the Facility Create - Risk Types on Modify Risk Types Selection List Window.
	TohitEnter = Split(Field,"|")
	
	If arr_1(1)<>"" Then
	  If arr_1(1)="micTab" Then 
		JavavWindow(WinName).Activate 
		JavaWindow(WinName).JavaEdit(ObjName).Type micTab 
	  Else
	  	JavaWindow(WinName).JavaEdit(ObjName).WaitProperty "enabled",true,20000
        JavaWindow(WinName).JavaEdit(ObjName).Set arr_1(1)
        JavaWindow(WinName).JavaEdit(ObjName).Type micTab
        If Ubound(TohitEnter) > 0 Then
        JavaWindow(WinName).JavaEdit(ObjName).Type micReturn	
        End If
	  End If 
	End If
	If Err.Description <> "" Then 
		Err.Clear  
	End If 
Win_Enter_In_A_TextBox=True
End Function 

'****************************************************************************************************************************
'Function	: Win_Click_On_Button
'Description	: activates the appropriate window and clicks on specified Button'
'****************************************************************************************************************************

Function Win_Click_On_Button (Win_Obj_Pro_Val) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"|") 
	Set WinName = Description.Create 
	arr_2 = split(arr_1(0),"=") 
	WinName(arr_2(0)).Value = arr_2(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_2 = split(arr_1(i),"=") 
		If arr_2(1) <> "" Then 
			ObjName(arr_2(0)).Value = arr_2(1) 
		End If 
	Next
	
	If value <> "" Then
			JavaWindow(WinName).Activate
			JavaWindow(WinName).Javabutton(ObjName).WaitProperty "enabled",true,50000
			JavaWindow(WinName).Javabutton(ObjName).Click
			If JavaWindow(WinName).Javabutton(ObjName).Exist Then
			JavaWindow(WinName).Javabutton(ObjName).Click	
			End If
		Else 
			JavaWindow(WinName).Activate
			JavaWindow(WinName).Javabutton(ObjName).WaitProperty "enabled",true,50000
			JavaWindow(WinName).Javabutton(ObjName).Click
	End If
	
'	If value <> ""  Then
'		JavaWindow(WinName).Activate
'		With JavaWindow(WinName) 
'		.Javabutton(ObjName).WaitProperty "enabled",true,50000
'		.Javabutton(ObjName).Click
'		.Javabutton(ObjName).Click
'		End With
'		Else
'		JavaWindow(WinName).Activate
'		With JavaWindow(WinName) 
'			.Javabutton(ObjName).WaitProperty "enabled",true,50000
'			.Javabutton(ObjName).Click 
'		End With
'	End If
Win_Click_On_Button=True
End Function 

'****************************************************************************************************************************
'Function	: Win_Select_Radio_Button
'Description	: activates the appropriate window and clicks on specified Radio Button'
'****************************************************************************************************************************

Function Win_Select_Radio_Button (Win_Obj_Pro_Val) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"|") 
	Set WinName = Description.Create 
	arr_2 = split(arr_1(0),"=") 
	WinName(arr_2(0)).Value = arr_2(1)
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_2 = split(arr_1(i),"=") 
		If arr_2(1) <> "" Then 
			ObjName(arr_2(0)).Value = arr_2(1) 
		End If 
	Next 
	With JavaWindow(WinName) 
		.JavaRadioButton(ObjName).WaitProperty "enabled",true,1000
		.JavaRadioButton(ObjName).Set "ON"
	End With
Win_Select_Radio_Button=True
End Function

'****************************************************************************************************************************
'Function	: Win_Select_List_Box
'Description	: activates the appropriate window and selects the text from the list box.
'****************************************************************************************************************************

Function Win_Select_List_Box (Win_Obj_Pro_Val) 
	On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next
	items_count=JavaWindow(WinName).JavaList(ObjName).GetROProperty("items count")
		For iCount = 0 to items_count-1
			strItem=JavaWindow(WinName).JavaList(ObjName).GetItem (iCount)
				If Trim(strItem) = Trim(arr_1(1)) Then
					'JavaWindow(WinName).JavaList(ObjName).Select arr_1(1)
					JavaWindow(WinName).JavaList(ObjName).Select strItem
					JavaWindow(WinName).JavaList(ObjName).Type micTab
					Win_Select_List_Box = True
					Exit For
				Else
					Win_Select_List_Box = False
				End If
		Next
End Function 


'*****************************************************************************************************************************
'Function      :Menuoption
'Description   : Funtion to select an option from the menu(Without Alt Keys, by using the value).
'**************************************************************************************************************************
Function MenuOption(Win_Objs_Val)

	Ind_Vals = split(Win_Objs_Val,"|") 
	arr_1 = split(Ind_Vals(0),"=") 
	value = Ind_Vals(1)

	Set WinName = Description.Create 
		WinName(arr_1(0)).Value = arr_1(1)

		If Instr(value,"…") Then 
			value = Replace(value,"…","...") 
		End If 
	set menu = Description.Create
		menu("menuobjtype").value=2
		
	Window(WinName).Activate
		If Window(WinName).Exist(20) then
			Window(WinName).Winmenu(menu).select value
		End If
End Function

'****************************************************************************************************************************
'Function	: SelectTab
'Description	: Funtion to select Tabs from all notebooks
'****************************************************************************************************************************'

Function SelectTab (Win_Value) 
	Win = split(Win_Value,"~") 
	Winargs = split(Win(0),"=") 
	
	Set WinName = Description.Create 
		WinName("to_class").Value = "JavaWindow" 
		WinName(Winargs(0)).Value = Winargs(1)
		
	Set windTab = Description.Create 
		WindTab("to_class").Value = "JavaTab"
		
	JavaWindow(WinName).JavaTab(WindTab).Select win(1)
	JavaWindow(WinName).JavaTab(WindTab).Type micTab
	wait 2
SelectTab=True
End Function

'****************************************************************************************************************************
'Function	: Win_Click_On_Composite
'Description	: Clicks on specified text in a Composite object
'****************************************************************************************************************************

Function Win_Click_On_Composite (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
 	 
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	
	If Vals(0) = "michome" Then
		JavaWindow(WinName).JavaTree(ObjName).Type michome
		Win_Click_On_Composite = True
		Else
	flag = false
	TextinColumn = Split(Field,"|")
	If Ubound(TextinColumn) > 0 Then
		SearchinColumn = TextinColumn(1)
		flag = True
	End If
	
	Set Context_Menu = Description.Create
    Context_Menu("menuobjtype").Value = "3"
	Context_Menu("index").Value = "0"

	wait 1
		JavaWindow(WinName).Activate
		JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
		JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
	wait 1
		Dim objCB
		Set objCB= CreateObject("Mercury.Clipboard")
		str_1 = objCB.GetText
		
		visibletext1 = AddDelimeter(str_1)
		visibletext2= Replace(visibletext1,"""","")
		visibletext3=split(visibletext2,chr(13))

If flag = True Then
	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = Split(visibletext4,"|")
		
	If Trim(ActualText(SearchinColumn-1)) = Vals(0) Then
		If Vals(1)=1 then
			JavaWindow(WinName).JavaTree(ObjName).Select i-1
			Win_Click_On_Composite = True
				else
			JavaWindow(WinName).JavaTree(ObjName).Select i-1
			JavaWindow(WinName).JavaTree(ObjName).Activate i-1
			Win_Click_On_Composite = True
		End if
		Exit For
	End If
	Next
Else
	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
	If Instr(ActualText,Vals(0)) Then
		If Vals(1)=1 then
			JavaWindow(WinName).JavaTree(ObjName).Select i-1
			Win_Click_On_Composite = True
				else
			JavaWindow(WinName).JavaTree(ObjName).Select i-1
			JavaWindow(WinName).JavaTree(ObjName).Activate i-1
			Win_Click_On_Composite = True
		End if
		Exit For
	End If
	Next
End If
End If
End Function

'*******************************************Win_Click_On_A_CheckButton**************************************************
'Function	: Win_Click_On_A_CheckButton
'Description	: This function Verifies for CheckBox and performs the required operation(Check/Uncheck)
'***********************************************************************************************************************

Function Win_Click_On_A_CheckButton(Win_Obj_Pro_Val) 

On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 

        Dim ter 
        ter = JavaWindow(WinName).JavaCheckBox(ObjName).GetROProperty("checked")

	If Ucase(arr_1(1))="CHECK" Then 
	  If ter= "OFF" Then
          Javawindow(WinName).JavaCheckBox(ObjName).Set "ON"
          Else
          End If
	   ElseIf Ucase(arr_1(1))="UNCHECK" Then
          If ter= "ON" Then
      	  Javawindow(WinName).JavaCheckBox(ObjName).Set "OFF"
          Else
          End If
       End If 
Win_Click_On_A_CheckButton=True
End Function 


'*******************************************Win_Click_On_A_Composite_CheckButton****************************************
'Function	: Win_Click_On_A_Composite_CheckButton
'Description	: This function Verifies for CheckBox on a composite field and performs the required operation(Check/Uncheck)
'***********************************************************************************************************************

Function Win_Click_On_A_Composite_CheckButton(Win_Obj_Pro_Val) 

On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Val = Split(arr_1(1),"|")
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("nativeclass").Value = "SWT_Window0"	
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 

	If Val(1)="Check" Then 
	  Window(WinName).WinListView(ObjName).SetItemState Val(0), micChecked
	  Win_Click_On_A_Composite_CheckButton=True
	  ElseIf Val(1)="Uncheck" Then
	  Window(WinName).WinListView(ObjName).SetItemState Val(0), micunChecked
	  Win_Click_On_A_Composite_CheckButton=True
    End If 
End Function 


'****************************************************************************************************************************
'Function	:Win_Get_From_TextBox 
'Description	:Verifies for the text entered in the textfield.
'****************************************************************************************************************************'
Function Win_Get_From_TextBox (Win_Obj_Pro_Val) 
	On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	arr_4 = split(arr_1(1),"=") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	
	If Instr(field,"Edit") Then
			JavaWindow(WinName).JavaEdit(ObjName).WaitProperty "enabled",true,20000
	    	ret = JavaWindow(WinName).JavaEdit(ObjName).GetROProperty("text")
	    ElseIf Instr(field,"Static") Then
	    	JavaWindow(WinName).JavaStaticText(ObjName).WaitProperty "enabled",true,20000
	    	ret = JavaWindow(WinName).JavaStaticText(ObjName).GetROProperty("text")
	    ElseIf Instr(field,"List") or Instr(field,"Combo") Then
	    	JavaWindow(WinName).JavaList(ObjName).WaitProperty "enabled",true,20000
	    	ret = JavaWindow(WinName).JavaList(ObjName).GetROProperty("text")
	End If
	
	final = trim(ret) 
	Win_Get_From_TextBox = final&"~"&"\"&field'&".png"
	t=t+1	
End Function 


'****************************************************************************************************************************
'Function	:Win_Click_On_Text 
'Description	:activates the appropriate window and clicks on specified Text
'****************************************************************************************************************************

Function Win_Click_On_Text (Win_Obj_Pro) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro,"~") 
	Win = split(arr_1(0),"|") 
	arr_2 = split(Win(0),"=") 

		Set WinName = Description.Create
		WinName(arr_2(0)).Value = arr_2(1)
        WinName("to_class").Value = "JavaWindow"

		Set TreeView = Description.Create
		TreeView("to_class").Value = "JavaTree"
		TreeView("index").Value = "0"
		
			JavaWindow(WinName).Click 1,1
				
		    If Win(2)="1" Then 
				JavaWindow(WinName).JavaTree(TreeView).Select arr_1(1)
				Win_Click_On_Text=True
			End If 
		
			If Win(2)="2" Then 
				JavaWindow(WinName).JavaTree(TreeView).Activate arr_1(1)
				Win_Click_On_Text=True
	        End If
End Function

'****************************************************************************************************************************
'Function 	:WarningCall () 
'Description	:Function Clicks on the Yes option in the "Warning" window
'****************************************************************************************************************************
Function WarningCall() 
	Set WarningWin = Description.Create 
	WarningWin("regexpwndtitle").Value = "Warning" 
	WarningWin("regexpwndclass").Value = "SWT_Window0" 'LIQ Java Update
	
	If Ucase(value) = "NO" Then
	Set NoButton = Description.Create 
	NoButton("text").Value = "&No" 
	NoButton("nativeclass").Value = "BUTTON" 'LIQ Java Update
	With Window(WarningWin) 
		.WaitProperty "enabled",true,25000
		.WinObject(NoButton).Click 
	End With 'Window(WarningWin) 
	Else
	Set YesButton = Description.Create 
	YesButton("text").Value = "&Yes" 
	YesButton("nativeclass").Value = "BUTTON" 'LIQ Java Update
	With Window(WarningWin) 
		.WaitProperty "enabled",true,25000 'Updated the Wait  time from 50000 to 25000 by MKT
		.WinObject(YesButton).Click 
	End With 'Window(WarningWin) 
	End If
	WarningCall = True
End Function

'****************************************************************************************************************************
'Function 	:Warning1Call () 
'Description	:Function Clicks on the Yes option in the "Please Confirm" window
'****************************************************************************************************************************
Function Warning1Call() 
	Set WarningWin = Description.Create 
	WarningWin("regexpwndtitle").Value = "Please confirm" 
	WarningWin("regexpwndclass").Value = "SWT_Window0" 'LIQ Java Update
	
	If Ucase(value) = "NO" Then
	Set NoButton = Description.Create 
	NoButton("text").Value = "&No" 
	NoButton("nativeclass").Value = "BUTTON" 'LIQ Java Update
	With Window(WarningWin) 
		.WaitProperty "enabled",true,25000
		.WinObject(NoButton).Click 
	End With 'Window(WarningWin) 
	Else
	Set YesButton = Description.Create 
	YesButton("text").Value = "&Yes" 
	YesButton("nativeclass").Value = "BUTTON" 'LIQ Java Update
	With Window(WarningWin) 
		.WaitProperty "enabled",true,25000 'Updated the Wait  time from 50000 to 25000 by MKT
		.WinObject(YesButton).Click 
	End With 'Window(WarningWin) 
	End If
	Warning1Call = True
End Function


'****************************************************************************************************************************
'Function 	:QuestionCall () 
'Description	:Function Clicks on the Yes option in the "Question" window
'****************************************************************************************************************************
'

Function QuestionCall () 
	Set WarningWin = Description.Create 
	WarningWin("regexpwndtitle").Value = "Question" 
	WarningWin("regexpwndclass").Value = "SWT_Window0" 'LIQ Java Update
	Set YesButton = Description.Create 
	YesButton("text").Value = "&Yes" 
	YesButton("nativeclass").Value = "BUTTON" 'LIQ Java Update
	
	With Window(WarningWin) 
		.WaitProperty "enabled",true,25000
		.WinObject(YesButton).Click 
	End With 'Window(WarningWin) 
	QuestionCall = True
End Function 


'****************************************************************************************************************************
'Function 	:Toggle_Auto_Do_It () 
'Description	:It's a scenario based function which chooses the Preferred RI option set to "Yes" at all times.
'****************************************************************************************************************************

Function Toggle_Auto_Do_It () 

On Error Resume Next
	 	 
	Set WinName = Description.Create 
		WinName("to_class").Value = "JavaWindow"
		WinName("text").Value = "Deal Servicing Group.*"
		
	Set ObjName = Description.Create 
		ObjName("to_class").Value = "JavaTree"
		ObjName("index").Value = "0"
		
	Set ButtonName = Description.Create
		ButtonName("to_class").Value = "JavaButton"
		ButtonName("index").Value = "2"
		
	Set Context_Menu = Description.Create
    	Context_Menu("menuobjtype").Value = "3"
		Context_Menu("index").Value = "0"
	wait 1
		JavaWindow(WinName).Activate
		JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
		JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
	wait 1
		Dim objCB
			Set objCB= CreateObject("Mercury.Clipboard")
		str_1 = objCB.GetText
		visibletext1 = AddDelimeter(str_1)
		visibletext2= Replace(visibletext1,"""","")
		visibletext3=split(visibletext2,chr(13))
'		visibletext3 = ubound(visibletext3)
		visibletext4 = Replace(visibletext3(1),chr(10),"") ' Auto Do It Status comes on the first row. So hard coded with 1
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = Split(visibletext4,"|")

	If Trim(Ucase(ActualText("0"))) = "Y" Then
	Toggle_Auto_Do_It=True
	Else
	JavaWindow(WinName).Javabutton(ButtonName).Click
	Toggle_Auto_Do_It=True
	End If
End Function

'****************************************************************************************************************************
'Function	: Win_Click_On_Multi_Composite
'Description	: Clicks on specified text in a Composite object by comparing multiple values in the same row.
'****************************************************************************************************************************

Function Win_Click_On_Multi_Composite (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
	Vals = Split(Vals,"|")
 	Items = Ubound(Vals) 
 	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	 rows = "0"

	ClickStatus = Split(Field,"|")
	If Ubound(ClickStatus) > 0 Then
		ClickStatus1 = ClickStatus(1)
		Else
		ClickStatus1 = 1
	End If
	
				If field=FieldName And Diff = False Then
				
				Else
				Set Context_Menu = Description.Create
    				Context_Menu("menuobjtype").Value = "3"
					Context_Menu("index").Value = "0"
				wait 1
					JavaWindow(WinName).Activate
					JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
					JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
				wait 1
			
			Dim objCB
					Set objCB= CreateObject("Mercury.Clipboard")
					str_1 = objCB.GetText
					FieldName=field
					Diff = False
					str_1 = AddDelimeter(str_1)
				End If
		
		visibletext2= Replace(str_1,"""","")
		visibletext3=split(visibletext2,chr(13))
		
	 	 JavaWindow(WinName).JavaTree(ObjName).Type micHome


	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
		
		Select Case Items
		
		
		Case "0"

			If Instr(ActualText,Vals(0))>0 Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite = True
				End if
				Exit For
			End If
		
		
		Case "1"

			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite = True
				End if
				Exit For
			End If

		
		Case "2"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite = True
				End if
				Exit For
			End If
			
		Case "3"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite = True
				End if
				Exit For
			End If
		End Select
	Next
End Function

'******************************************************************************************************************************************************************************************
'Function	: Win_Click_On_Multi_Composite_Tolerance
'Description	: Clicks on specified text in a Composite object by comparing multiple values in the same row. This functions clicks if the amount has a tolearnce amounr of +/- 0.01.
'******************************************************************************************************************************************************************************************

Function Win_Click_On_Multi_Composite_Tolerance (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
	Items = Ubound(Vals) 
 	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	 rows = "0"

	ClickStatus = Split(Field,"|")
	If Ubound(ClickStatus) > 0 Then
		ClickStatus1 = ClickStatus(1)
		Else
		ClickStatus1 = 1
	End If
	
				If field=FieldName And Diff = False Then
				
				Else
				Set Context_Menu = Description.Create
    				Context_Menu("menuobjtype").Value = "3"
					Context_Menu("index").Value = "0"
				wait 1
					JavaWindow(WinName).Activate
					JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
					JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
				wait 1
			
			Dim objCB
					Set objCB= CreateObject("Mercury.Clipboard")
					str_1 = objCB.GetText
					FieldName=field
					Diff = False
					str_1 = AddDelimeter(str_1)
				End If
		
		visibletext2= Replace(str_1,"""","")
		visibletext3=split(visibletext2,chr(13))
		
	 	 JavaWindow(WinName).JavaTree(ObjName).Type micHome
	 	 
	 	
	 	 If Items <> 0 Then
	 	 	If isnumeric(Vals(1)) Then
	 	 		ToleranceVal1=trim(formatnumber(Vals(1)+0.01,2))
				ToleranceVal2=trim(formatnumber(Vals(1)-0.01,2))
			End If
		Else
			If isnumeric(Vals(0)) Then
	 	 		ToleranceVal1=trim(formatnumber(Vals(0)+0.01,2))
				ToleranceVal2=trim(formatnumber(Vals(0)-0.01,2))
			End If
	 	 End If

	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
		
		Select Case Items
		
		
		Case "0"

			If Instr(ActualText,Vals(0))>0 or Instr(ActualText,ToleranceVal1)>0 or Instr(ActualText,ToleranceVal2)>0 Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite_Tolerance = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite_Tolerance = True
				End if
				Exit For
			End If
		
		
		Case "1"

			If (Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0) Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite_Tolerance = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite_Tolerance = True
				End if
				Exit For
			End If

		
		Case "2"
			If (Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 and Instr(ActualText,Vals(2))>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0 and Instr(ActualText,Vals(2))>0) Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite_Tolerance = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite_Tolerance = True
				End if
				Exit For
			End If
			
		Case "3"
			If (Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0) or (Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0) Then
				If ClickStatus1=1 then
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					Win_Click_On_Multi_Composite_Tolerance = True
				else
					For rows = 1 To i-1
						JavaWindow(WinName).JavaTree(ObjName).Type micDwn
					Next
					wait 1
					JavaWindow(WinName).JavaTree(ObjName).Type micReturn
					Win_Click_On_Multi_Composite_Tolerance = True
				End if
				Exit For
			End If
		End Select
	Next
End Function

'****************************************************************************************************************************
'Function	: Win_Click_On_PopUp
'Description	: Created this function when pop up windows won't identify as java objects and requires complete hireacy to identify the Javawindow popup messsage.
				' Here we are using non java code to identify the pop up widow and performing the action.
'****************************************************************************************************************************

Function Win_Click_On_PopUp (Win_Obj_Pro_Val) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"|") 
	Set WinName = Description.Create 
	arr_2 = split(arr_1(0),"=") 
	WinName(arr_2(0)).Value = arr_2(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_2 = split(arr_1(i),"=") 
		If arr_2(1) <> "" Then 
			ObjName(arr_2(0)).Value = arr_2(1) 
		End If 
	Next
	Window(WinName).Activate
	With Window(WinName) 
		.WinObject(ObjName).WaitProperty "enabled",true,50000 'Updated the Wait  time from 1000 to 50000 by MKT on 1 Dec 2010
		.WinObject(ObjName).Click
	End With
Win_Click_On_PopUp=True
End Function 

'****************************************************************************************************************************
'Function	:Win_Get_From_Composite
'Description	:reports whether the specified text is present in the composite or not.
'****************************************************************************************************************************

Function Win_Get_From_Composite(Win_Obj_Pro_Val)
	On Error Resume Next
	Dim ret2(200)
	Dim A(20,20)
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2) 
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	
			If field=FieldName And Diff = False Then
				
			Else
					Set Context_Menu = Description.Create
	    				Context_Menu("menuobjtype").Value = "3"
						Context_Menu("index").Value = "0"
					wait 1
						JavaWindow(WinName).Activate
						JavaWindow(WinName).JavaTree(ObjName).Click 20, 9, micRightBtn
						JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
					wait 1
				
					Dim objCB
					wait 2
					Set objCB = CreateObject("Mercury.Clipboard")
						str_1 = objCB.GetText
						Set objCB = Nothing	
						FieldName=field
						Diff = False
						str_1 = AddDelimeter(str_1)
			End If
	
visibletext1=Replace(str_1,"   ","")
visibletext1 = Replace(visibletext1,chr(10),"")
visibletext1 = Replace(visibletext1,"	","")
visibletext2=split(visibletext1,chr(13))
ColNames = Split(visibletext2(0),"|")
ColCount = GetCount(ColNames)-1

for i=0 to GetCount(visibletext2)-1
 arr = Split(visibletext2(i),"|")
  for j=0 to ColCount
	 if GetCount(arr)-1 < ColCount and j >GetCount(arr)-1 then
		 A(i,j) = "Blank"
	 else
		 A(i,j) = arr(j)
	 end if
 next
next 
Win_Get_From_Composite = A
End Function


'****************************************************************************************************************************
'Function	: Win_Get_From_Multi_Composite
'Description	: Clicks on specified text in a Composite object by comparing multiple values in the same row.
'****************************************************************************************************************************

Function Win_Get_From_Multi_Composite (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
	Vals = Split(Vals,"|")
 	Items = Ubound(Vals) 
 	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next
	
	
			If field=FieldName And Diff = False Then
				
				Else
						Set Context_Menu = Description.Create
		    				Context_Menu("menuobjtype").Value = "3"
							Context_Menu("index").Value = "0"
						wait 1
							JavaWindow(WinName).Activate
							JavaWindow(WinName).JavaTree(ObjName).Click 20, 9, micRightBtn
							JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
						wait 1
					
					Dim objCB
					wait 2
							Set objCB= CreateObject("Mercury.Clipboard")
							str_1 = objCB.GetText
							FieldName=field
							Diff = False
							str_1 = AddDelimeter(str_1)
			End If

	
		visibletext2= Replace(str_1," / ","/")
		visibletext2= Replace(visibletext2,"""","")
		visibletext3=split(visibletext2,chr(13))
		
	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
		
		Select Case Items
		
		Case "1"

			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 Then
				Win_Get_From_Multi_Composite = True
				Exit For
			End If

			
		Case "2"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 Then
				Win_Get_From_Multi_Composite = True
				Exit For
			End If
			
		Case "3"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 Then
				Win_Get_From_Multi_Composite = True
				Exit For
			End If
		
		Case "4"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 and Instr(ActualText,Vals(4))>0 Then
				Win_Get_From_Multi_Composite = True
				Exit For
			End If		
				
		End Select
	Next
End Function


'*****************************************************************************************************************************************
'Function	: Win_Get_From_Multi_Composite_Tolerance
'Description	: Clicks on specified text in a Composite object by comparing multiple values with a tolerance of +/- 0.01 in the same row.
'*****************************************************************************************************************************************

Function Win_Get_From_Multi_Composite_Tolerance (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
	Items = Ubound(Vals) 
 	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next
	
	
			If field=FieldName And Diff = False Then
				
				Else
						Set Context_Menu = Description.Create
		    				Context_Menu("menuobjtype").Value = "3"
							Context_Menu("index").Value = "0"
						wait 1
							JavaWindow(WinName).Activate
							JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
							JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
						wait 1
					
					Dim objCB
							Set objCB= CreateObject("Mercury.Clipboard")
							str_1 = objCB.GetText
							FieldName=field
							Diff = False
							str_1 = AddDelimeter(str_1)
			End If

	
		visibletext2= Replace(str_1," / ","/")
		visibletext2= Replace(visibletext2,"""","")
		visibletext3=split(visibletext2,chr(13))
		
		ToleranceVal1=trim(formatnumber(Vals(1)+0.01,2))
		ToleranceVal2=trim(formatnumber(Vals(1)-0.01,2))

		
	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
		
		Select Case Items
		
		Case "1"

			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of +.001"
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of -.001"
				Exit For
			End If

			
		Case "2"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 and Instr(ActualText,Vals(2))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of +.001"
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0 and Instr(ActualText,Vals(2))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of -.001"
				Exit For
			End If
			
		Case "3"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of +.001"
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of -.001"
				Exit For
			End If
		
		Case "4"
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,Vals(1))>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 and Instr(ActualText,Vals(4))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				Exit For
			End If
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal1)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 and Instr(ActualText,Vals(4))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of +.001"
				Exit For
			End If	
			
			If Instr(ActualText,Vals(0))>0 and Instr(ActualText,ToleranceVal2)>0 and Instr(ActualText,Vals(2))>0 and Instr(ActualText,Vals(3))>0 and Instr(ActualText,Vals(4))>0 Then
				Win_Get_From_Multi_Composite_Tolerance = True
				testdescription = testdescription & " with Loan IQ difference of -.001"
				Exit For
			End If				
				
		End Select
	Next
End Function


 '****************************************************************************************************************************
'Funtion 	:Create_Object
'Description 	:Creates an Object and returns the same
 '****************************************************************************************************************************

Function Create_Object(Object_Pro)
   Prop_Val = Split(Object_Pro,"|")
   Set Obj_Name = Description.Create 
		For i = 0 To UBound(Prop_Val)  
			arr_1 = split(Prop_Val(i),"=") 
			If arr_1(1) <> "" Then 
				Obj_Name(arr_1(0)).Value = arr_1(1) 
			End If 
		Next 

  set Create_Object = Obj_Name
		
 End Function
 
 
 '****************************************************************************************************************************
'Function	: GetValueToGlobal
'Description	: Funtion to Capture the Loan Alias Name from an application and writes in to Excel file(Global).
'****************************************************************************************************************************'


 Function GetValueToGlobal(Win_properties) 

 On Error Resume Next 
	Window_array1 = split(Win_properties,"~") 
	CompositeArray = Window_array1(0) &"|"& Window_array1(1)

	Window_name = split(Window_array1(0),"=")
	Valu = split(Window_name(0),"~")
		
	Value = Window_array1(2)
		
	Validi=Split(Value,"|")
		sheetnumber=int(Validi(0))
		rownumber = int(Validi(1))
		columnnumber=int(Validi(2))

		If Instr(field,"Edit") Then
					
			Set WinName = Description.Create 			'Window Name
			    WinName(Window_name(0)).Value = Window_name(1) 
				WinName("to_class").Value = "JavaWindow"
			
			Set ObjName = Create_Object(Window_array1(1)) 		' Object Properties
		
		        JavaWindow(WinName).Activate
			
			text=JavaWindow(WinName).JavaEdit(ObjName).GetROProperty("text")
			
			var1 = Split(text,"%")
			Value2Global = var1(0)
		ElseIf Instr(field,"Composite") Then
			actual1 = Win_Get_From_Composite(CompositeArray)
			If field = "Composite_RepaymentSchedule" Then
				var1 = actual1(1,1)
				var = Split(Var1,chr(34))
				var1 = abs(var(1))
				Value2Global = var1
			ElseIf field = "Composite_InterestPayment" Then
				var1 = actual1(1,2)
				var = Split(Var1,chr(34))
				var1 = abs(var(1))
				Value2Global = var1
			ElseIf field = "Composite_PrincipalPayment" Then
				var1 = actual1(1,4)
				var = Split(Var1,chr(34))
				var1 = abs(var(1))
				Value2Global = var1
			Else
				var1 = actual1(1,1)
				var = Split(Var1,chr(34))
				var1 = var(1) * 100
				Value2Global = var1
		End If
'			If field <> "Composite_RepaymentSchedule" Then
'				var1 = actual1(1,1)
'				var = Split(Var1,chr(34))
'				var1 = var(1) * 100
'				Value2Global = var1
'			Else
'				var1 = actual1(1,1)
'				var = Split(Var1,chr(34))
'				var1 = abs(var(1))
'				Value2Global = var1
'			End If
		End If

	
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(GlobalPath)
	Set objWorksheet = objWorkbook.Worksheets(sheetnumber)	
	    objWorksheet.Cells(rownumber,columnnumber)=Value2Global
            objExcel.DisplayAlerts = False
	    objWorkbook.Save
		objExcel.Enableevents=False 
	    objWorkbook.Close
	Set objWorkbook = Nothing
	Set objLastSheet = Nothing
	Set objLastSheet = Nothing
	    objExcel.Quit 
	Set objExcel = Nothing
	
  GetValueToGlobal=True

 End Function


'****************************************************************************************************************************
'Function	:Win_Get_From_WindowTextBox 
'Description	:Verifies for the text entered in the textfield.
'****************************************************************************************************************************'
Function Win_Get_From_WindowTextBox (Win_Obj_Pro_Val) 
	
	On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	arr_4 = split(arr_1(1),"=") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	ret = Window(WinName).WinEdit(ObjName).GetROProperty("text")
    final = trim(ret) 
	Win_Get_From_WindowTextBox = final&"~"&"\"&field'&".png"
	t=t+1
End Function 

'*******************************Recovery Function*****************************************************
'Recovery_Cache: This Function is Called by UFT when the Warning window  is popped Up for a non -business day scenario.
'*****************************************************************************************************
Function RecoveryFunction1(Object)
Setting("DefaultTimeout") = 1000
Set WarnWin = Description.Create 
	    WarnWin("regexpwndtitle").Value = "Warning.*" 
	    WarnWin("regexpwndclass").Value = "SWT_Window0" 
Set WarnWinEditor = Description.Create
		WarnWinEditor("nativeclass").Value = "Edit"
	    WarnWinEditor("attached text").Value = "WARNING.*" 

Set YesButton = Description.Create
	    YesButton("text").Value = "&Yes" 
        YesButton("nativeclass").Value = "Button" 
        If Window(WarnWin).Exist(1) Then
        	 Actual = Window(WarnWin).WinEditor(WarnWinEditor).GetROProperty("text")
        	 
        If Instr(Actual,"non-business day")>0Then
		    If Window(WarnWin).Exist Then
			    With Window(WarnWin) 
				.WaitProperty "enabled",true,1000 
				.WinObject(YesButton).Click 
		            End With
			End If
        End If
        End If
       
Setting("DefaultTimeout") = 1000
End Function

'*******************************Update Values*****************************************************************
'Update Values
'**************************************************************************************************************

Function UpdateValues(Path)
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(Path)
	Set objWorksheet = objWorkbook.Worksheets(1)	
	    'objWorksheet.Cells(rownumber,columnnumber)=Value2Global
            objExcel.DisplayAlerts = False
	    objWorkbook.Save
		objExcel.Enableevents=False 
	    objWorkbook.Close
	Set objWorkbook = Nothing
	Set objLastSheet = Nothing
	Set objLastSheet = Nothing
	    objExcel.Quit 
	Set objExcel = Nothing
	
	End Function
	

'****************************************************************************************************************************
'Function	: Win_Get_From_ButtonExit 
'Description	: Function which verifies the specified property of a button if It doesnot exist,Qtp Exits the test.
'****************************************************************************************************************************'
Function Win_Get_From_ButtonExit (Win_Obj_Pro_Val) 

	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	arr_4 = split(arr_1(1),"=") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	JavaWindow(WinName).JavaCheckBox(ObjName).WaitProperty "enabled",true,50000
	s = JavaWindow(WinName).JavaCheckBox(ObjName).GetROproperty("value") 	
		If s= "1"  Then
		s= "Check"
	Elseif s="0" then
		s="Uncheck"
	End If
	Win_Get_From_ButtonExit = s&"~"&"\"&field'&".png"
End Function


'****************************************************************************************************************************
'Function	: Right_Click_Select 
'Description	: Function uses to right click on mouse event and selects the value from the list of options.
'****************************************************************************************************************************'

Function Right_Click_Select(val)
	On Error Resume Next
	Val1 = Split(val,"|")
	Set WinName = Description.Create 
		WinName("to_class").Value = "JavaWindow"
		WinName("text").Value = "FusionBanking.*"
		
	Set ObjName = Description.Create 
		ObjName("to_class").Value = "JavaTree"
		ObjName("index").Value = "0"
		
	Set Context_Menu = Description.Create
    	Context_Menu("menuobjtype").Value = "3"
		Context_Menu("index").Value = "0"
	wait 1
		JavaWindow(WinName).Activate
		JavaWindow(WinName).JavaTree(ObjName).OpenContextMenu "[Favorites];"&Val1(0)&""
		JavaWindow(WinName).WinMenu(Context_Menu).Select Val1(1)
	Right_Click_Select = True		
End Function

'****************************************************************************************************************************
'Function	: Win_SelectEnter_In_A_TextBox
'Description	: Funtion to click on Composite Field and enters the text.
'****************************************************************************************************************************'
Function Win_SelectEnter_In_A_TextBox (Win_Obj_Pro_Val) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = arr_1(1)
 
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
	arr_3 = split(arr_2(i),"=") 
		if i <> 3  and i <> 4  Then
			If arr_3(1) <> "" Then 
				ObjName(arr_3(0)).Value = arr_3(1) 
			End If 
	  	End If
	Next 

	 a = split(arr_2(3),"=")
	 b = split(arr_2(4),"=")  
	x = Cint(a(1))
	y = Cint(b(1))
	
	JavaWindow(WinName).Activate
	JavaWindow(WinName).JavaTree(ObjName).Click  x , y
	JavaWindow(WinName).JavaTree(ObjName).Type "-"
	JavaWindow(WinName).JavaTree(ObjName).Type Vals

End Function 

'****************************************************************************************************************************
'Function	: Win_Click_On_Composite_Tolerance
'Description	: Clicks on specified text with +/- 0.01 tolerance in a Composite object by comparing values in the same row.
'****************************************************************************************************************************

Function Win_Click_On_Composite_Tolerance (Win_Obj_Pro_Val) 
	
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|")
	Vals = Split(arr_1(1),"|")
	Vals = Split(Vals,"|")
 	 	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 
	 rows = "0"

				If field=FieldName And Diff = False Then
				
				Else
				Set Context_Menu = Description.Create
    				Context_Menu("menuobjtype").Value = "3"
					Context_Menu("index").Value = "0"
				wait 1
					JavaWindow(WinName).Activate
					JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
					JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
				wait 1
			
			Dim objCB
					Set objCB= CreateObject("Mercury.Clipboard")
					str_1 = objCB.GetText
					FieldName=field
					Diff = False
					str_1 = AddDelimeter(str_1)
				End If
		
		visibletext2= Replace(str_1,"""","")
		visibletext3=split(visibletext2,chr(13))
		
	 	 JavaWindow(WinName).JavaTree(ObjName).Type micHome

		ToleranceVal1=trim(formatnumber(Vals(0)+0.01,2))
		ToleranceVal2=trim(formatnumber(Vals(0)-0.01,2))

	For i = 1 To ubound(visibletext3)
		visibletext4 = Replace(visibletext3(i),chr(10),"")
		visibletext4 = Replace(visibletext4,"	","")
		ActualText = visibletext4
		
			If Instr(ActualText,Vals(0))>0 or Instr(ActualText,ToleranceVal1)>0 or Instr(ActualText,ToleranceVal2)>0 Then
				If Vals(1)=1 then
					JavaWindow(WinName).JavaTree(ObjName).Select i-1
					Win_Click_On_Composite_Tolerance = True
				else
					JavaWindow(WinName).JavaTree(ObjName).Select i-1
					JavaWindow(WinName).JavaTree(ObjName).Activate i-1
					Win_Click_On_Composite_Tolerance = True
			End If
				Exit For
		End If
	Next
End Function

'*******************************************Win_Click_On_A_VerifyCheckButton*********************************************
'Function	: Win_Click_On_A_VerifyCheckButton
'Description	: This function Verifies for CheckBox 
'************************************************************************************************************************

Function Win_Click_On_A_VerifyCheckButton(Win_Obj_Pro_Val) 
On Error Resume Next 
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1) 
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 

        Dim ter 
        ter = JavaWindow(WinName).JavaCheckBox(ObjName).GetROProperty("checked")

	If Ucase(arr_1(1))="CHECK" Then 
	  If ter= "OFF" Then
          'Window(WinName).WinButton(ObjName).Click
	  ResNew = False
          Else
	  ResNew = True
          End If
	
       ElseIf arr_1(1)="Uncheck" Then
          If ter= "ON" Then
      	  'Window(WinName).WinButton(ObjName).Click
	  ResNew = False
          Else
	  ResNew = True
          End If
       End If

Win_Click_On_A_VerifyCheckButton=ResNew
End Function 


'****************************************************************************************************************************
'Function	: Win_Verify_Radio_Button
'Description	: Verifies whether the Radio Button is selected by default or not.
'****************************************************************************************************************************

Function Win_Verify_Radio_Button (Win_Obj_Pro_Val) 
	On Error Resume Next
	arr_1 = split(Win_Obj_Pro_Val,"|") 
	Set WinName = Description.Create 
	arr_2 = split(arr_1(0),"=") 
	WinName(arr_2(0)).Value = arr_2(1)
		
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2)+1  
		arr_2 = split(arr_1(i),"=") 
		If arr_2(1) <> "" Then 
			ObjName(arr_2(0)).Value = arr_2(1) 
		End If 
	Next 
	
	ter = JavaWindow(WinName).JavaRadioButton(ObjName).GetROProperty("value")
		
	If ter ="1" Then 
	Win_Verify_Radio_Button=True
	Else
	Win_Verify_Radio_Button=False
	End If
End Function

'****************************************************************************************************************************
'Function	:  Win_Get_From_ColumnRowComposite
'Description	:Clicks on a specified text present in a particular row and Column in the composite.
'****************************************************************************************************************************
Function Win_Get_From_ColumnRowComposite(Win_Obj_Pro_Val)
	On Error Resume Next
	Dim ret2(200)
	Dim A(20,20)
	arr_1 = split(Win_Obj_Pro_Val,"~") 
	arr_2 = split(arr_1(0),"|") 
	Vals = Split(arr_1(1),"|")
	
	Set WinName = Description.Create 
	arr_3 = split(arr_2(0),"=") 
	WinName(arr_3(0)).Value = arr_3(1)
	WinName("to_class").Value = "JavaWindow"
	
	Set ObjName = Description.Create 
	For i = 1 To UBound(arr_2) 
		arr_3 = split(arr_2(i),"=") 
		If arr_3(1) <> "" Then 
			ObjName(arr_3(0)).Value = arr_3(1) 
		End If 
	Next 

	flag = false
	TextinColumn = Split(Field,"|")
	If Ubound(TextinColumn) > 0 Then
		SearchinColumn = TextinColumn(1)
		flag = True
	End If
	
			If field=FieldName And Diff = False Then
				
			Else
					Set Context_Menu = Description.Create
	    				Context_Menu("menuobjtype").Value = "3"
						Context_Menu("index").Value = "0"
					wait 1
						JavaWindow(WinName).Activate
						JavaWindow(WinName).JavaTree(ObjName).Click 20, 10, micRightBtn
						JavaWindow(WinName).WinMenu(Context_Menu).Select "Copy All To Clipboard"
					wait 1
				
					Dim objCB
						Set objCB= CreateObject("Mercury.Clipboard")
						str_1 = objCB.GetText
						FieldName=field
						Diff = False
						str_1 = AddDelimeter(str_1)
			End If
	
visibletext1=Replace(str_1,"   ","")
visibletext1 = Replace(visibletext1,chr(10),"")
visibletext1 = Replace(visibletext1,"	","")
visibletext2=split(visibletext1,chr(13))
ColNames = Split(visibletext2(0),"|")
ColCount = GetCount(ColNames)-1

for i=0 to GetCount(visibletext2)-1
 arr = Split(visibletext2(i),"|")
  for j=0 to ColCount
	 if GetCount(arr)-1 < ColCount and j >GetCount(arr)-1 then
		 A(i,j) = "Blank"
	 else
		 A(i,j) = arr(j)
	 end if
 next
next 
				If Vals(1)<>"" And Vals(2)<>"" Then
					actual=A(Vals(1)-1,Vals(2)-1)
					actual = Trim(actual)
				End If

If flag = True Then
	If instr(actual,Vals(0))>0 Then 
		If SearchinColumn = 1 Then
		For rows = 1 To Vals(1)-2
			JavaWindow(WinName).JavaTree(ObjName).Type micDwn
		Next
		Win_Get_From_ColumnRowComposite = True
		Else
		For rows = 1 To Vals(1)-2
			JavaWindow(WinName).JavaTree(ObjName).Type micDwn
		Next
		wait 1
			JavaWindow(WinName).JavaTree(ObjName).Type micReturn
		Win_Get_From_ColumnRowComposite = True
		End If
	End If
End If
End Function

'****************************************************************
'Function name: CME_LaunchApplication 
'Description: To Enter text value 
'Created by : Automation Team
'Modified by and date:Subhash Patil 
'****************************************************************
		
Function CME_LaunchApplication()        
    SystemUtil.CloseProcessByName("iexplore.exe")    
    SystemUtil.CloseProcessByName("chrome.exe")    
    SystemUtil.CloseProcessByName("excel.exe") 
    envURL = Environment.Value("EnvironmentName")
    
    Select Case  Trim(UCase(envURL))
		Case "FBLTEST" 
	    	strURL = "http://fv-test.farmcreditbank.com/#/?workspace=CME&board=Onboarding"
	    Case "FBLRSTG" 	
	    	strURL = "http://fblrstguxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
	    Case "FBLDATO" 	
	    	strURL = "http://fv-dato.farmcreditbank.com/#/?workspace=CME&board=Onboarding" 
	   
	    Case "FBLQA" 	
	    	strURL = "http://fv-qa.farmcreditbank.com/#/?workspace=CME&board=Onboarding"
	    Case "FBLDATV" 	
	    	strURL = "http://fv-datv.farmcreditbank.com/#/?workspace=CME&board=Onboarding"
	    Case "FBLDEMO" 	
	    	strURL = "http://fbldemouxp.nterprise.net:3002/#/?workspace=CME&board=Onboarding"   
	    Case "FBLDATN" 	
	    	strURL = "http://fbldatnuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
		Case "FBBUILD" 	
	    	strURL = "http://fbbuilduxp.nterprise.net:3002/#/?workspace=CME&board=Onboarding"
		Case "FBLTRAIN" 	
	    	strURL = "http://fv-train.farmcreditbank.com/#/?workspace=CME&board=Onboarding" 
		Case "FBLASSN" 	
	    	strURL = "http://fblassnuxp.nterprise.net:3002/#/?workspace=CME&board=Onboarding" 
		Case "FBLDATI" 	
	    	strURL = "http://fv-dati.farmcreditbank.com/#/?workspace=CME&board=Onboarding"
	    Case "FBLINTDEV" 	
	    	strURL = "http://fv-intdev.farmcreditbank.com/#/?workspace=CME&board=Onboarding" 
	   	Case "FBLDATF" 	
	    	strURL = "http://fbldatfuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
    	Case "FBLINTTST" 	
    		strURL = "http://fv-inttst.farmcreditbank.com/#/?workspace=CME&board=Onboarding"
    	Case "FBLINTTEST"
    		strURL = "http://fblinttstuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
		Case "FBLOBSDEV" 	
	    	strURL = "http://fblobsdevuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
		Case "FBLDATJ" 	
	    	strURL = "http://fbldatjuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"	
		Case "FBLDATL" 	
	    	strURL = "http://fbldatluxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding"
	    Case "FBLDEV" 	
	    	strURL = "http://fbldevuxp.develop.fcbt:3002/#/?workspace=CME&board=Onboarding" '"http://fv-dev.farmcreditbank.com/#/?workspace=CME&board=Onboarding"


	End Select 
    
    SystemUtil.Run "iexplore.exe", strURL ,,,3

	CME_application.Sync 
'	If LCase(Trim(CME_application.GetROProperty("url"))) <> LCase(Trim(strURL)) Then
'		msgbox "Wrong Environment URL"
'		Call CME_ExitTest()
'	End If
'	CME_application.GetROProperty("url")
	
	'Browser("title:=.*").ClearCache
End Function





'****************************************************************
'Function name: CME_DDTScreen 
'Description: To Handle DDT Screen
'Created by : Divya V C
'Modified by and date:
'****************************************************************

Function CME_DDTScreen()   

	'/ Creating description object for DDT Screen Web Elements
    Set objddtAssign=Description.Create
    objddtAssign.Add "micClass","WebElement"
    objddtAssign.Add "class","gridBoxCell"
    objddtAssign.Add "width","70"
    objddtAssign.Add "height","14"
    '/ Getting all the Childobjects for created Description object
    Set objofficerFields=CME_application.Childobjects(objddtAssign)
    intRownum=0
    intTotalAssignedOfficers=0
    
    '/ Looping across the fields to get innertext of assigned fields
    For iDDT = 0 To objofficerFields.count-1
    	
            strAssigned_Officers= objofficerFields(iDDT).getRoproperty("innertext")
        '/ If No Officer assigned  then Performing the action to Assign officer 
        If strAssigned_Officers="" Then
            intRownum=iDDT
            intTotalAssignedOfficers=intTotalAssignedOfficers+1
            objofficerFields(intRownum).click        
            For j = 1 To intTotalAssignedOfficers
	            set dropDownBtn=CME_application.WebElement("attribute/fieldName:=Assigned To DD").WebEdit("visible:=true") 'WebElement("outerhtml:=.*ddButton.png.*")
	        	BoolfieldExist=dropDownBtn.Exist(5)
	        	If BoolfieldExist=True Then
		            dropDownBtn.Click
		            wait 1
		            set objwsh=CreateObject("wscript.shell")
					objwsh.SendKeys " "
'		            Set dropDownItem=CME_application.WebElement("html tag:=DIV","class:=gridBoxBody","height:=138").WebElement("html tag:=DIV","class:=gridBoxCell","innertext:=PLB Loan Admin","visible:=true","index:=0") 'list item description
'		            If dropDownItem.Exist(5)=true Then
'		                dropDownItem.click
'		                wait 1
'		               
'					End If
		            strvar=CME_application.WebElement("attribute/fieldname:=Entity DD").WebEdit("html tag:=input","visible:=true").GetROProperty("title")
					If strvar="" Then
			   			set dropDownBtn=CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=Entity DD","index:=0").WebElement("outerhtml:=.*ddButton.png.*")
			   	  	 	BoolfieldExist=dropDownBtn.Exist(5)
				   		If BoolfieldExist Then
					   		dropDownBtn.Click
					 		wait 1
					 		set objwsh=CreateObject("wscript.shell")
					 		objwsh.SendKeys " "
				 		End If
			 		End If
			 		
			 		strpro=CME_application.WebElement("attribute/fieldname:=Product DD").WebEdit("html tag:=input","visible:=true").GetROProperty("title")
					If strpro="" Then
			   			set dropDownBtn=CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=Product DD","index:=0").WebElement("outerhtml:=.*ddButton.png.*")
			   	  	 	BoolfieldExist=dropDownBtn.Exist(5)
				   		If BoolfieldExist Then
					   		dropDownBtn.Click
					 		wait 1
					 		set objwsh=CreateObject("wscript.shell")
					 		objwsh.SendKeys " "
				 		End If
			 		End If
	            	Exit for
	         
	                
	        Else 
	        CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 	
	       End If
    	Next
  End If
  
Next
set objwsh=CreateObject("wscript.shell")
		objwsh.SendKeys "{TAB}"
		set objwsh=Nothing
		
End Function

'****************************************************************
'Function name: CME_ClickExistingDeal 
'Description: To select existing deals
'Created by : Automation Team
'Modified by and date:
'****************************************************************

Function CME_ClickExistingDeal()

	Do 
		Set objStatus=Description.Create
		objStatus.Add "micClass","WebElement"
		objStatus.Add "Class","gridBoxCell"
		objStatus.Add "x",64
		objStatus.Add "abs_x",64
		
		Set objStatusColl=CME_application.ChildObjects(objStatus)
		
		For i = 0 To objStatusColl.count-1
			strStatusVal= objStatusColl(i).getroproperty("innertext")
			If not strStatusVal="" Then
			strNewStatusVal=strStatusVal
			intrownum=i
			objStatusColl(intrownum).DoubleClick
			Exit do
			Exit for 	
			End If
		Next
		
		CME_application.WebElement("innerhtml:=Next","html tag:=A").Click
		If CME_application.WebElement("innerhtml:=Next","html tag:=A","color:=graytext").Exist(3) then
			Exit do
		End If
	loop

End Function



'****************************************************************
'Function name: CME_ReportFailed 
'Description: To Generate Report for Failed steps
'Created by : EVRY Automation Team
'Modified by and date:
'****************************************************************

Function CME_ReportFailed(i)

	Reporter.ReportEvent 1,Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1
	
	Set objExcel = CreateObject("Excel.Application")
	objExcel.visible = False
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	resFailedVerify=resFailedVerify+1
	Dim val
	val = objWorksheet.UsedRange.Rows.Count
	val =val+1
	objWorksheet.Cells(val,1) = field
	objWorksheet.Cells(val,2) = testdescription &": " & field & "-"& scrnShotTitle &"| Step.No" & i+1 & " |"
	objWorksheet.Cells(val,3) ="Failed"
	objWorksheet.Cells(val,3).interior.color=vbred
	objWorksheet.Cells(val,4) = now()	
	'Set cellRange = objWorksheet.Cells(val,7)
	'objWorksheet.Hyperlinks.Add cellRange, scrnShotURL
	
	
	objWorksheet.Cells(val,7) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
	objWorksheet.Columns("A:G").EntireColumn.AutoFit
	objWorkbook.save
	'objWorkbook.Application.Quit
	objWorkbook.Close(True)
	
	Set objWorksheet = Nothing
	Set objWorkbook = Nothing
	
	objExcel.Quit
	Set objExcel = Nothing
End Function

Function CME_ReportWarning(i)

	Reporter.ReportEvent 3,Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1
	
	Set objExcel = CreateObject("Excel.Application")
	objExcel.visible = False
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	'resFailedVerify=resFailedVerify+1
	Dim val
	val = objWorksheet.UsedRange.Rows.Count
	val =val+1
	objWorksheet.Cells(val,1) = field
	objWorksheet.Cells(val,2) = "Test failed:Application not able to find:"&field & "| Step.No" & i+1 & " |"
	objWorksheet.Cells(val,3) ="Warning"
	objWorksheet.Cells(val,3).interior.color=VBYellow
	objWorksheet.Cells(val,4) = now()	
	'Set cellRange = objWorksheet.Cells(val,7)
	'objWorksheet.Hyperlinks.Add cellRange, scrnShotURL
	
	
	objWorksheet.Cells(val,7) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
	objWorksheet.Columns("A:G").EntireColumn.AutoFit
	objWorkbook.save
	'objWorkbook.Application.Quit

	objWorkbook.Close(True)

	Set objWorksheet = Nothing
	Set objWorkbook = Nothing
	
	objExcel.Quit
	Set objExcel = Nothing
End Function

'****************************************************************
'Function name: CME_EnterTextReportFailed 
'Description: To Generate Report for Failed steps for text fields
'Created by : EVRY Automation Team
'Modified by and date:
'****************************************************************

Function CME_EnterTextReportFailed(i)

	Reporter.ReportEvent 1,Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1
	
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	resFailedVerify=resFailedVerify+1
	Dim val
	val = objWorksheet.UsedRange.Rows.Count
	val =val+1
	objWorksheet.Cells(val,1) = field
	objWorksheet.Cells(val,2) = "Test failed:Value should not be empty in" &field& "| Step.No" & i+1 & " |"
	objWorksheet.Cells(val,3) ="Failed"
	objWorksheet.Cells(val,3).interior.color=vbred
	objWorksheet.Cells(val,4) = now()	
	
	
			
	objWorkbook.save
	objWorkbook.Application.Quit

End Function

'****************************************************************
'Function name: CME_VerifyLoginReportFailed 
'Description: To verify failed report for login 
'Created by : EVRY Automation Team
'Modified by and date:
'****************************************************************

Function CME_VerifyLoginReportFailed(i)

	Reporter.ReportEvent 1,Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1

	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	resFailedVerify=resFailedVerify+1
	Dim val
	val = objWorksheet.UsedRange.Rows.Count
	val =val+1
	objWorksheet.Cells(val,1) = field
	objWorksheet.Cells(val,2) = "Test failed:Invalid Login credentials" & "| Step.No" & i+1 & " |"
	objWorksheet.Cells(val,3) ="Failed"
	objWorksheet.Cells(val,3).interior.color=vbred
	objWorksheet.Cells(val,4) = now()	
	
	
	objWorkbook.save
	objWorkbook.Application.Quit

End Function

'****************************************************************
'Function name: CME_VerifyFieldValReportFailed 
'Description: To verify failed report for field 
'Created by : EVRY Automation Team
'Modified by and date:
'****************************************************************

Function CME_VerifyFieldValReportFailed(i)

	Reporter.ReportEvent 1, Field,testdescription & "| Step.No" & i+1 & " |"
	resFailed=resFailed+1

	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	resFailedVerify=resFailedVerify+1
	Dim val
	val = objWorksheet.UsedRange.Rows.Count
	val =val+1
	field = Replace(field, "||","_")
	objWorksheet.Cells(val,1) = field
	objWorksheet.Cells(val,2) = "Test failed the value in "&field&" not matched with Expected value" & "| Step.No" & i+1 & " |"
	objWorksheet.Cells(val,3) ="Failed"
	objWorksheet.Cells(val,3).interior.color=vbred
	objWorksheet.Cells(val,4) = now()	
	
	
	objWorksheet.Cells(val,7) = "=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot		
	objWorksheet.Columns("A:G").EntireColumn.AutoFit
	objWorkbook.save
	objWorkbook.Application.Quit

End Function




'****************************************************************
'Function name: CME_Value_from_Repository 
'Description: To fetch value from object repository excel file
'Created by : Muzaffar A
'Modified by and date:
'****************************************************************

Function CME_Value_from_Repository(Arg,colName)
	
	OR_Path = "C:\Users\"& Environment.Value("UserName") & "\Documents\CME_Repository\CME_object_repository.xlsx"
	Dim conn, recordSet, query
	Set conn = createobject("ADODB.CONNECTION")
	'conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=\\nterprise.net\Bankdata\QA\CME_Automation\Repository\CME_object_repository.xlsx;Extended Properties='Excel 12.0 Xml;HDR=YES';"
	conn.ConnectionString = "Provider=Microsoft.ACE.OLEDB.12.0;Data Source=" & OR_Path &"; Extended Properties='Excel 12.0 Xml;HDR=YES';"
	conn.Open 
	
	Set recordSet = CreateObject("ADODB.Recordset") 
		query = "Select * from [Repository$] where LogicalName='" & Arg & "'"
		recordSet.Open query,conn,3,3 
		
	If recordSet.EOF=False Then
		CME_Value_from_Repository=recordSet(colName)
		
	End If	
	conn.Close
	Set recordSet=nothing
	Set conn=nothing
End Function

'****************************************************************
'Function name: CME_CatchException 
'Description: To catch exception
'Created by : Pavan Kumar
'Modified by and date:
'****************************************************************

Function CME_CatchException()
Do 
	if CME_application.WebElement("html tag:=A","tabindex:=0","Attribute/fieldname:=OK","index:=0").Exist(10) then
		CME_application.WebElement("html tag:=A","tabindex:=0","Attribute/fieldname:=OK","index:=0").Click
	else
		Exit do
	End If
loop
End Function



'****************************************************************
'Function name: CME_CloseLatestOpenedBrowser 
'Description: To Close recently opened browsers
'Created by : Divya V C
'Modified by and date:
'****************************************************************
Function CME_CloseLatestOpenedBrowser()     

Dim oDescription
Dim BrowserObjectList
Dim oLatestBrowserIndex

Set oDescription=Description.Create
oDescription("micclass").value="Browser"
Set BrowserObjectList=Desktop.ChildObjects(oDescription)
oLatestBrowserIndex=BrowserObjectList.count-1
If oLatestBrowserIndex > 0 Then
	Browser("creationtime:="&oLatestBrowserIndex).close
End If


Set oDescription=Nothing
Set BrowserObjectList=Nothing

End Function




'''*******************************************************************************************************************************
'************************************************************************************************
'Function name: ConvertTimes 
'Description: Picks the entire execution time  of each script in hours, mins, and sec
'Created by : Subhash Patil
'Modified by and date:  11/22/2018
'*************************************************************************************************
'************************************************************
Function ConvertTimes()	''			(intTotalSecs)
	Dim intHours,intMinutes,intSeconds,Time
	EndTime=now
	intTotalSecs=DateDiff("s", startTime, EndTime)
	intHours = intTotalSecs \ 3600
	intMinutes = (intTotalSecs Mod 3600) \ 60
	intSeconds = intTotalSecs Mod 60
	ConvertTimes = tim(intHours) & " h : " & tim(intMinutes) & " mins : " & tim(intSeconds) & " secs"	
	ConvertTimes= mid(ConvertTimes, 8)	

End Function

'************************************************************
Function tim(v) 
	tim = Right("0" & v, 2) 
End Function

'************************************************************

'****************************************************************
'Function name: CME_GetDealNum 
'Description: For getting deal number from deal tree
'Created by : Subhash Patil 
'Modified by and date:
'****************************************************************

Function CME_GetDealNum()		
		   
	intdealval=CME_application.WebElement("html tag:=SPAN","innertext:=.* - Status: .*","index:=1").GetROProperty("innertext")
	intdealvalArr=split(intdealval, " - Status:")
	intdealnum = Replace(intdealvalArr(0), "Deal #", "")
	CME_GetDealNum=intdealnum
	
End Function

'****************************************************************
'Function name: CME_Verify_DealNuminDDTScreen 
'Description: For searching deal number in DDT Screen
'Created by : Subhash Patil 
'Modified by and date:
'****************************************************************

Function CME_Verify_DealNuminDDTScreen()	 
			''intdealnum ="1723"		    
		    
			Dim strPopupMsg
		Set objInfopop=Description.Create
		    objInfopop.Add "micClass","WebElement"
		    objInfopop.Add "Class","gridBoxCell"
		    objInfopop.Add "width","156"
		    objInfopop.Add "height","14"
		    objInfopop.Add "x","1017"
		     		    
		    Set objInfo = CME_application.ChildObjects(objInfopop)
		    cnt = objInfo.count
		    BoolfieldExist=False
		    	For i = 0 To cnt step 1
			    	strPopupMsg = objInfo(i).GetRoProperty("innertext")
			    	
			    	If instr(1,strPopupMsg,intdealnum)>0 Then
			    		BoolfieldExist=True
				        'CME_resPassed='CME_resPassed+1
					    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
						r=ResultStatus(TTC,Tcs_Executed ,resPassed,resFailed,MyTime)
						'''''msgbox "Pass"
						Call CME_ExitTest() 
					Else
''						CME_ReportFailed(i)
''						CME_resFailed=CME_resFailed+1
						BoolfieldExist=False
					End if
			    Next 	
			If BoolfieldExist=False Then
			   CME_ReportFailed(i)
			   CME_resFailed=CME_resFailed+1
			   Call CME_ExitTest() 
			End If

End Function


Function CME_Optimist()
Optimist_Application.SlvToggleButton("name:=ArrowToggle","parent text:=My Portfolios").Set "ON"
wait 5
Optimist_Application.SlvDialog("devname:=DropDownPopup","slvtypename:=dialog").SlvTreeView("slvtypename:=tree view").Expand Win_Title_Field
wait 5
Optimist_Application.SlvDialog("devname:=DropDownPopup","slvtypename:=dialog").SlvTreeView("slvtypename:=tree view").Select Field
wait 4
set obj= Optimist_Application.SlvObject("visible:=True","slvtypename:=DataGridCellPresenter","text:="& Value)

wait 4
Set objWsh=Createobject("Wscript.shell") 
wait 1

		   obj.Click
		   wait 1
		   objWsh.SendKeys "{ENTER}"
		   wait 10
		   Set objWsh=Nothing
Optimist_Application.SlvTabStrip("name:=tabModel","slvtypename:=tab").Select "Loading "

End Function



Function Optimist_LaunchApplication()

SystemUtil.CloseProcessByName("iexplore.exe")	
	SystemUtil.CloseProcessByName("chrome.exe")	
	
	Set objIE = CreateObject("InternetExplorer.Application")
	objIE.Navigate "http://opttestfe.develop.fcbt:81/Optimist8"
	hnd= Browser("CreationTime:=0").Object.hwnd
	 '' Code added to Maximise the browser
	Window("hwnd:=" &hnd).Maximize	
'Browser("CreationTime:=0").OpenNewTab()
'Browser("CreationTime:=1").Sync
'Browser("CreationTime:=1").Navigate "http://opttestfe.develop.fcbt:81/Optimist8"
End Function

'****************************************************************
'Function name: CME_ExpandLastDealNum 
'Description: Function will single click/Expand the last created deal in Dashboard
'Created by : Shruthi Aila
'Modified by and date:
'****************************************************************

Function  CME_ExpandLastDealNum(i) 
		BoolfieldExist=False
		Set arrowBtn=CME_application.WebElement("Class:=hyperlink","html tag:=A","innertext:=>>")
		BoolfieldExist=arrowBtn.Exist(10)
		if BoolfieldExist=true Then
           arrowBtn.Click
			set objDealNum=Description.Create
	        objDealNum.Add "micClass","WebElement"
	        objDealNum.Add "Class","gridBoxCell"
	        objDealNum.Add "html tag","DIV"
	        objDealNum.Add "width",59
	        Set objDealNumColl=CME_application.ChildObjects(objDealNum)
	        
	        For k = 0 To objDealNumColl.count-1
		        If k=objDealNumColl.count-1 Then
		        	Set lastDeal=objDealNumColl(k)
		        	lastDeal.Click
		        	ReportPassed(i)
		        	'CME_resPassed='CME_resPassed+1	
		        End If
	        Next           
        End if
	    
	    If BoolfieldExist=false Then 'If arrow button/link does not exist it is clicking on the largest page number to get to the last page faster. 	
		    Do 							 'The largest page number is always previous to Next button/link
				Set largestNum=CME_application.WebElement("Class:=hyperlink","html tag:=A","attribute/fieldname:=Next","visible:=true")
					If largestNum.exist(10)=True Then
					Set largestNum=CME_application.WebElement("Class:=hyperlink","html tag:=A","attribute/fieldname:=Next","visible:=true").Object.PreviousSibling
					largestNum.click
					else
						set objDealNum=Description.Create
				        objDealNum.Add "micClass","WebElement"
				        objDealNum.Add "Class","gridBoxCell"
				        objDealNum.Add "html tag","DIV"
				        objDealNum.Add "width",59
				        Set objDealNumColl=CME_application.ChildObjects(objDealNum)
				        
				        For k = 0 To objDealNumColl.count-1
					        If k=objDealNumColl.count-1 Then
					        	Set lastDeal=objDealNumColl(k)
					        	lastDeal.Click
					        	ReportPassed(i)
					        	'CME_resPassed='CME_resPassed+1	
					        End If
				        Next
				        Exit do
					End If
					
					If CME_application.WebElement("Class:=hyperlink","html tag:=A","attribute/fieldname:=Next","color:=graytext","outerhtml:=.*disabled.*").Exist(5) Then
					set objDealNum=Description.Create
				        objDealNum.Add "micClass","WebElement"
				        objDealNum.Add "Class","gridBoxCell"
				        objDealNum.Add "html tag","DIV"
				        objDealNum.Add "width",59
				        Set objDealNumColl=CME_application.ChildObjects(objDealNum)
				        
				        For k = 0 To objDealNumColl.count-1
					        If k=objDealNumColl.count-1 Then
					        	Set lastDeal=objDealNumColl(k)
					        	lastDeal.Click
					        	ReportPassed(i)
					        	'CME_resPassed='CME_resPassed+1	
					        End If
				        Next		
				
						Exit do
					End If
			Loop
		End if 
		
       Set lastDeal=nothing    
 	   set objDealNum=nothing
 	   Set largestNum=nothing
       Set arrowBtn=nothing 
End  Function

'****************************************************************
'Function name: CME_LoginData(field) 
'Description: Function to parse xml document and returns password value
'Created by : Muzaffar A. 
'Modified by and date:
'****************************************************************


Function CME_LoginData()
	
	Set filesys = CreateObject("Scripting.FileSystemObject")
	loginXML = "\\nterprise.net\Bankdata\QA\CME_Automation\Config\CME_LoginData.xml"
	If filesys.FileExists(loginXML) Then
	   Const XMLDataFile = "\\nterprise.net\Bankdata\QA\CME_Automation\Config\CME_LoginData.xml"
		Set xmlDoc = CreateObject("Microsoft.XMLDOM")
		xmlDoc.Async = False
		xmlDoc.Load(XMLDataFile) 'Loading CME_LoginData.xml document
		Set pwdVal=xmlDoc.SelectSingleNode("//username[@id='" & LCase(Environment.Value("UserName")) & "']/password") 'Selecting node <password> using it's relative xpath
		CME_LoginData=trim(pwdVal.text) 'Getting password value and assigning it to function name
	Else 
		Reporter.ReportEvent micFail, "Bad Login", "Please Provide with Password"
		On error goto 0
		Call CME_ExitTest() 
	End If 
	Set pwdVal=nothing
	Set filesys=nothing
	
End Function



'****************************************************************
'Function name: CaptureFailedObject(ByRef containerObj, ByRef testObj, ByVal scrnShotTitle)
'Description: Highlights the object where test fails and captures snapshot of it
'Created by : Muzaffar A. 
'Modified by and date:
'****************************************************************

Public Function CaptureFailedObject(ByRef containerObj, ByRef testObj, ByVal scrnShotTitle)
	set filesys=CreateObject("Scripting.FileSystemObject") 
'	
	If Not filesys.FolderExists(scrnShotFolder) Then ' if folder doesn't exist then create a new folder
		scrnShotFolder = filesys.CreateFolder (scrnShotFolder)  
	End If	
	
	If field<>"" Then
		field=Replace(field,"||","")
		Set objRegExp = New Regexp
		objRegExp.IgnoreCase = True
		objRegExp.Global = True
		objRegExp.Pattern = "[(?*"",\\<>&#~%{}+-=.@:\/!;]"
		field = objRegExp.Replace(field, "")
		Set objRegExp = Nothing
	End If
	Randomize 
	rndNum = Cint((10000*RND))
	scrnShotURL=scrnShotFolder  & "\"& "\"& CME_Get_TC_Title &"_"& field &"_Step_"& i &"_"& scrnShotTitle & rndNum &".png"
	'This code will highlight the object with red border then takes the screenshot of the page		
	testObj.FireEvent "onfocus"
	oldBorder = testObj.Object.style.border
	testObj.Object.style.border = "solid"
	testObj.Object.style.BorderColor = "red"
	containerObj.CaptureBitmap scrnShotURL, True
	testObj.Object.style.border = oldBorder
   
    Set testObj=Nothing
    set filesys=Nothing
    


	
End Function
'****************************************************************
'Function name: CaptureScreen(scrnShotTitle)
'Description: Captures the snapshot of the screen
'Created by : Muzaffar A. 
'Modified by and date:
'****************************************************************

Public Function CaptureScreen(scrnShotTitle)
	
	set filesys=CreateObject("Scripting.FileSystemObject") 

	If Not filesys.FolderExists(scrnShotFolder) Then ' if folder doesn't exist then create a new folder
		scrnShotFolder = filesys.CreateFolder (scrnShotFolder)  
	End If	
	If field<>"" Then
		field=Replace(field,"||","")
		Set objRegExp = New Regexp
		objRegExp.IgnoreCase = True
		objRegExp.Global = True
		objRegExp.Pattern = "[(?*"",\\<>|&~%{}+-=.@:||\/!;]"
		field = objRegExp.Replace(field, "")
		Set objRegExp = Nothing
	End If
	Randomize 
	rndNum = Cint((10000*RND))
	scrnShotURL=scrnShotFolder  & "\"& CME_Get_TC_Title &"_"& field &"_Step_"& i &"_"& scrnShotTitle & rndNum &".png" 

	If Trim(UCase(Commands)) = "CME_VERIFYPDFDOC" Then
		'Browser("CreationTime:=1").CaptureBitmap scrnShotURL, True
		Desktop.CaptureBitmap scrnShotURL, True
	Else 
		'CME_application.CaptureBitmap scrnShotURL, True
		Desktop.CaptureBitmap scrnShotURL, True
	End If
	
	
	set filesys = Nothing
	
End Function

'****************************************************************
'Function name: CME_DataFromDataBase()
'Description: Fetches record from database based on the query given in 'queryAction'
'Created by : Muzaffar A. 
'Modified by and date:12/27/2018
'Win_Title_Field - we can use this as an argument for our query if needed
'field - field name that we want to fetch data from
'****************************************************************
Function CME_DataFromDataBase()
		
		Set objConnection = CreateObject("ADODB.Connection")
		Set objRecordSet = CreateObject("ADODB.Recordset")
		objConnection.open "provider=sqloledb;Server=FBLTESTBE.develop.fcbt; Database=FBCME;Trusted_Connection=Yes"
		RunAction "queryAction",oneiteration
		 
		strQry=Environment.Value("query")
		If Win_Title_Field<>"" Then
			strQry=strQry & Win_Title_Field
		End If 
			
		objRecordSet.Open strQry, objConnection
		If objRecordSet.EOF=False Then
			If isnull(objRecordSet.Fields(field).Value)=True Then
				rec=""
			Else 
				rec=objRecordSet.Fields(field).Value
			End If 
		Else 
			rec="NO RECORD FOUND"
		End If 
		CME_DataFromDataBase = rec	
		Set objConnection = Nothing
		Set objRecordSet = Nothing
	End Function


'****************************************************************
'Function name: CME_UsernameQuery()
'Description: Fetches user's full name for routing deal
'Created by : Muzaffar A. 
'Modified by and date:09/15/2020

'****************************************************************
Function CME_UsernameQuery()
	usr = Environment("UserName")
	strQry = "SELECT [emp_fname], [emp_lname] FROM [FBCME].[dbo].[t_ccs_admin_emp] where [emp_login_nm] = '" & usr &"'"
	   
'	Set CME_application = Browser("name:=CME-Onboarding").Page("title:=CME-Onboarding")
'	strURL = lcase(CME_application.GetROProperty("URL"))
'	strURL = Replace(strURL, "http://", "")
'	ArrUrl = Split(strURL, ".")
'	strEnv = Replace(ArrUrl(0), "uxp", "")
'	domainName = ArrUrl(1)
	
	Set objConnection = CreateObject("ADODB.Connection")
	Set objRecordSet = CreateObject("ADODB.Recordset")
	strEnv = "FBLTEST"
	objConnection.Open "provider=sqloledb;Server=" & strEnv & "BE.develop.fcbt; Database=FBLoanIQ;Trusted_Connection=Yes"
	
	objRecordSet.Open strQry, objConnection
	If objRecordSet.EOF = False Then
	    If IsNull(objRecordSet.Fields.Item(0)) = True OR IsNull(objRecordSet.Fields.Item(1)) Then
	        rec = ""
	    Else
	        fName = objRecordSet.Fields.Item(0)
	        lName = objRecordSet.Fields.Item(1)
	        fullName = Trim(fName) & " " & trim(lName)
	    End If
	Else
	    fullName = "NO RECORD FOUND"
	End If
	CME_UsernameQuery = fullName
	Set objConnection = Nothing
	Set objRecordSet = Nothing	
		
End Function


'****************************************************************
'Function name: CME_ReportCSi(Win_Title_Field)
'Description: Adds new sheet to Result file and reports CSi Pre-Closing/Closing Documents
'****************************************************************
Public Function CME_ReportCSi(Win_Title_Field)
	
	Set CSifso = CreateObject("Scripting.FileSystemObject")
	    'Check to see if the file already exists in the destination folder
	    If CSifso.FileExists(resPath) Then
			'Check to see if the file is read-only
	        If CSifso.GetFile(resPath).Attributes And 1 Then 
	            'The file exists and is read-only.
	            'Remove the read-only attribute
	            CSifso.GetFile(resPath).Attributes = CSifso.GetFile(resPath).Attributes - 1
	        
	        End If
	    End If    
	Set CSiobjExcel = CreateObject("Excel.Application")
	CSiobjExcel.visible=False
	Set CSiobjWorkbook = CSiobjExcel.Workbooks.Open(resPath)
	
	'CSiobjWorkbook.Application.DisplayAlerts=False
	For iSheet = 1 To CSiobjWorkbook.Worksheets.Count
	    If Trim(UCase(CSiobjWorkbook.Worksheets(iSheet).Name)) = Trim(UCase(Win_Title_Field)) Then
	        exists = True
	    End If
	Next

	If Not exists Then
		CSiobjWorkbook.Worksheets.Add, CSiobjWorkbook.Worksheets(CSiobjWorkbook.Worksheets.Count)
		CSiobjWorkbook.Worksheets(CSiobjWorkbook.Worksheets.Count).Name = Win_Title_Field
	End If
	
	Set CSiSheet=CSiobjWorkbook.Worksheets(Win_Title_Field)
	CSiSheet.Activate
	With CSiSheet
		'Adding column headers to CSi results sheets
	    .Range("A1:F1") = Array("Documents Appeared in Selection Logic", "Missing Expected Documents", "Rendered Expected Documents", "Not Rendered Expected Documents","Unexpected Documents", "Screenshot")
	    .Range("A1:F1").Font.Bold = True
	    .Range("A1:F1").Interior.ColorIndex="40"
	    .Range("A1:F1").ColumnWidth="40"
	    .Range("A2:G2").RowHeight="350"
		.Cells(2,1)=generatedDocs'Generated Documents Column
		.Cells(2,2)=missingDoc 'Missing Documents Column
		.Cells(2,3)=renderedDocs 'Render Documents Column
		.Cells(2,4)=NotRenderedDocs 'Not Rendered Documents Column
		.Cells(2,5)=xtraDoc 'Unexpected Documents Column
		.Cells(2,6)="=HYPERLINK(""" & scrnShotURL &""", ""Click here for Screenshot"")"    '- Hyperlink in result file for screenshot
		.Cells.WrapText=true

	End With
	
	CSiobjExcel.ActiveWorkbook.Save
	CSiobjExcel.ActiveWorkbook.Close
'	CSiobjWorkbook.Save
'	CSiobjWorkbook.Application.Quit
	CSiobjExcel.Quit
	Set CSiSheet=Nothing
	Set CSiobjWorkbook = Nothing
	Set CSiobjExcel = Nothing
	Set CSifso = Nothing
End Function
	

'****************************************************************
'Function name: CME_DynamicWait()
'Description: Dynamically waits for loading to complete	
'****************************************************************

Function CME_DynamicWait()
		wait 1
		'CME_application.Image("file name:=\?_twr_=loadcircle\.gif","visible:=True").WaitProperty "visible", "true"
		Set objPlsWait = CME_application.WebElement("class:=topContainer|modal-body","html tag:=DIV","visible:=True", "index:=1")
		Set waitImg = CME_application.Image("class:=image","html tag:=IMG","file name:=\?_twr_=wait\.png","visible:=True")
		tmr = 0
		Do while  objPlsWait.Exist(1)
			syncMsg=objPlsWait.GetRoProperty("innertext")
			If instr(syncMsg,"Please Wait")>0 OR instr(syncMsg,"Connecting to External API")>0 OR instr(syncMsg,"Connecting to Credit Plus")>0 OR instr(syncMsg,"Retrieving Entity Information")>0 OR instr(syncMsg,"Building .*")>0 OR instr(syncMsg,"Adding .*")>0 Then
				
			
			Else 
				Exit Do
			End If
			If CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true").Exist(0.5) Then
				Exit Do
			End If
			tmr = tmr + 1
			If tmr >= 600 Then
				scrnShotTitle="TimedOut"
				Call CaptureScreen(scrnShotTitle)
				Field = "Loading Took Long"
				testdescription = "Unexpected Event"
				CME_ReportFailed(i)
	            CME_resFailed=CME_resFailed+1
				Call CME_ExitTest()
			End If
		Loop		       
	    set objPlsWait=nothing
	    tmr = 0
	    If CME_application.WebElement("class:=label","html tag:=DIV","innertext:=System Exception","visible:=true").Exist(0.5) Then 'If Systemexception occurs take screenshot, report, exit test
			CME_application.WebElement("class:=button","attribute/fieldName:=Show Details >>","visible:=true").Click
			wait 1
			scrnShotTitle="SystemException"
			Call CaptureScreen(scrnShotTitle)
			Field = "SystemExceptionError"
			testdescription = "SystemExceptionError"
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
			Call CME_ExitTest()
		ElseIf CME_application.Image("html tag:=IMG","file name:=\?_twr_=error\.png","visible:=true").Exist(0.2) Then 'If Error occurs take screenshot, report, exit test
			CME_application.Image("html tag:=IMG","file name:=\?_twr_=error\.png","visible:=true").Highlight
			scrnShotTitle="Error"
			Call CaptureScreen(scrnShotTitle)
			Field = "Error"
			testdescription = CME_application.Image("html tag:=IMG","file name:=\?_twr_=error\.png","visible:=true").Object.parentElement.innerText'"Error"
			testdescription = Replace(testdescription, vbCrLf, "")
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1

			Call CME_ExitTest()
			
		ElseIf CME_application.WebElement("class:=label","html tag:=DIV","innertext:=Please fill in .*","visible:=true").Exist(0.2) Then 'When message: Please fill in a valid ... appears
		
			scrnShotTitle="DataMissing"
			Call CaptureScreen(scrnShotTitle)
			Field = "DataMissing"
			testdescription = CME_application.WebElement("class:=label|dialog","html tag:=DIV","innertext:=Please fill in .*","visible:=true").GetROProperty("Innertext")
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1

			Call CME_ExitTest()	
		
			
		End If
		
	    
'	Set objLoading1 = CME_application.Image("file name:=\?_twr_=loadcircle\.gif","visible:=True")
'	Set objLoading2 = CME_application.Image("class:=image","html tag:=IMG","file name:=\?_twr_=wait\.png","visible:=True")
'	
'	Do while  objLoading1.Exist(1) OR objLoading2.Exist(0.5)
'		
'	Loop
	
'	Set objLoading2 = nothing
'	Set objLoading2 = Nothing
	    
	    
	    
End Function


'****************************************************************
'Function name: CME_CSi_PopUP()
'Description: Dynamically waits for loading to complete	
'****************************************************************

Function CME_CSi_PopUP()
	
	
Do 
    Set CSiMsg=CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true") 'Modified by Muzaffar A.
	Set btnOK=CSiMsg.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK.*","html tag:=A","visible:=true")
	'Set objPlsWait = CME_application.WebElement("class:=topContainer|modal-body","html tag:=DIV","visible:=True")
		
		'/Checking for CSi Pop up in the Sreen
    If CSiMsg.Exist(1) then
 
        '/clicking the OK  button
       If btnOK.Exist(1) Then
	    	btnOK.Click
	   End If 
    Else
    	
		If CME_application.WebElement("class:=label","html tag:=DIV","innertext:=Please Wait.*","visible:=True").Exist(1) Then 
    		
    	ElseIf CME_application.Image("class:=image","html tag:=IMG","file name:=\?_twr_=wait\.png","visible:=True").Exist(1) Then
    		
    	Else 
    		Exit do 
    	End If
         
        
    End  if 
    If CME_application.WebElement("class:=label","html tag:=DIV","innertext:=System Exception","visible:=true").Exist(1) Then    	
    		CME_application.WebElement("class:=button","attribute/fieldName:=Show Details >>","visible:=true").Click
			wait 1
			scrnShotTitle="SystemException"
			Call CaptureScreen(scrnShotTitle)
			Field = "SystemExceptionError"
			testdescription = "SystemExceptionError"
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
			Call CME_ExitTest()
    	
    End If
    
Loop
Set objPlsWait=Nothing
Set btnOK=Nothing	
Set CSiMsg=Nothing
End Function
	

Function VerifyPDFPage(srchVal)
	Set pdfPage=Browser("creationtime:=1")
		strTitle=pdfPage.GetROProperty("title")
		If pdfPage.Exist(10)=True and UCase(right(strTitle,4))=".PDF" OR UCase(right(strTitle,4))=".HTM"Then
			set oShell=createobject("WScript.shell")
			Set fso=CreateObject("Scripting.FileSystemObject") 
			set txtFile=fso.CreateTextFile("H:\CME_Automation\DOCS\pdfContent.txt", True)
		    Set oClipBoard=CreateObject("Mercury.Clipboard")
			pdfPage.highlight 'Bringing PDF page to focus
		    oShell.SendKeys "^a"
		 	wait 2
		  	oShell.SendKeys "^c"
		  	wait 2
			txtFile.Write(oClipBoard.GetText)
			set txtFile=fso.OpenTextFile("H:\CME_Automation\DOCS\pdfContent.txt",1, True)
			strPDFcontent=txtFile.ReadAll
			If instr(ucase(strPDFcontent),ucase(srchVal))>0 Then
		        ReportPassed(i)
		        'CME_resPassed='CME_resPassed+1
	    	Else
		    	scrnShotTitle="Value_Not_Found"
				Call CaptureFailedObject(CME_application, pdfPage, scrnShotTitle)
		        CME_ReportFailed(i)
		        CME_resFailed=CME_resFailed+1
		        'CME_FetchResultStatusAndEnterinFinalResults(resPath) 
	    	End If		
			set txtFile=Nothing
			Set oClipBoard=Nothing
			Set fso=Nothing
			set oShell=Nothing

		Else 
			scrnShotTitle="PDF_Not_Found"
			Call CaptureScreen(scrnShotTitle)
		    CME_ReportFailed(i)
		    CME_resFailed=CME_resFailed+1
		    'CME_FetchResultStatusAndEnterinFinalResults(resPath)
		   	On error goto 0
		    Call CME_ExitTest() 
		End If
		
End Function
	

	
	
Function dealModels_Error_PopUp()
	Do 
	    Set ErrMsg=CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true") 'Modified by Muzaffar A.
		Set btnOK=ErrMsg.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true")
		
			'/Checking for CSi Pop up in the Sreen
	    If ErrMsg.Exist(5) then
	
	        '/clicking the OK  button
	       If btnOK.Exist(2) Then
		    	btnOK.Click
		   End If 
	    Else
	    	
			If CME_application.Image("class:=image","html tag:=IMG","file name:=\?_twr_=wait\.png","visible:=True").Exist(2) Then
	    		wait 2
	    	Else 
	    		Exit do 
	    	End If
	         
	        
	    End  if 
	Loop
	Set objPlsWait=Nothing
	Set btnOK=Nothing	
	Set ErrMsg=Nothing
End Function	




Function CME_SavePDFfromBrowser(docFilePath)
	
'	hwnd=Browser("title:=.*CME.*","index:=1").GetROProperty("HWND")
'	Window("HWND:=" & hwnd).Activate
'	Set ObjWsh=CreateObject("Wscript.Shell")
'	Set ObjDR=CreateObject("Mercury.DeviceReplay")
''	Set Toolbar=Browser("title:=.*CME.*","index:=1").WinToolbar("regexpwndtitle:=Favorites Bar","index:=0")
''	Toolbar.click
''	wait 3
''	x1=Toolbar.GetroProperty("x")
''	y1=Toolbar.GetroProperty("y")
''	ObjDR.MouseClick x1,y1,2
''	ObjWsh.SendKeys ("{DOWN}")
''	ObjWsh.SendKeys ("{ENTER}")
''	wait 3
'	ObjWsh.SendKeys ("%{F}")
'	wait 2
'	ObjWsh.SendKeys ("{a}")
	wait 5
	Call RefreshPDFPage()
'	Set nextTab = Browser("Creationtime:=1")
'	If nextTab.Exist(10)=True Then
'		strTitle=nextTab.GetROProperty("title")
'		If Right(UCase(strTitle), 4) = ".PDF"  Then
'			openUrl = nextTab.GetROProperty("openurl")
'			If Instr(UCase(openUrl), "FBLDATO")>0 Then
'				nextTab.highlight
'				wait 1
'				nextTab.Refresh
'				nextTab.Sync
'			End If
'		
'		End If
'	End If
	Set pdfDoc= Browser("Creationtime:=1").WinObject("regexpwndtitle:=AVPageView","visible:=True")
	pdfDoc.highlight
	Set shScript = CreateObject("WScript.Shell")
	shScript.SendKeys "^+S"
	
	Set SaveDialogWindow=Browser("title:=.*CME.*","index:=1").Dialog("regexpwndtitle:=Save As","index:=0")
	
	If SaveDialogWindow.Exist(10) Then
		SaveDialogWindow.WinEdit("regexpwndclass:=Edit","index:=0").Set docFilePath
		SaveDialogWindow.WinButton("regexpwndclass:=Button","regexpwndtitle:=&Save","index:=0").Click
		SaveDialogWindow.WinButton("regexpwndclass:=Button","regexpwndtitle:=&Yes","index:=0").Click
'	else
'		msgbox "Save as window not opened"
	End If

	
	Set nextTab = Nothing	
	Set ObjWsh=Nothing
	Set ObjDR=Nothing
	Set SaveDialogWindow=Nothing

End Function



Function updateCMEDatafile()
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.WorkBooks.Open(Path)
	objExcel.Application.Visible = False
	objWorkbook.Save
	objWorkbook.Close
	Set objWorkbook = Nothing
	Set objExcel = Nothing
	'updateCMEDatafile = "envName"
End Function

Function Get_CME_Environment_Name()
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.WorkBooks.Open(Path)
	objExcel.Application.Visible = False
	Set activeWSh = objExcel.ActiveWorkbook.Worksheets("DataControlFile")
	'objWorkbook.Save
	''Msgbox activeWSh.Range("Env_Name")
	Environment.Value("EnvironmentName") = Trim(activeWSh.Range("Env_Name"))
	Get_CME_Environment_Name = Environment.Value("EnvironmentName")
	objExcel.Application.DisplayAlerts = False 
	objWorkbook.Close
	Set objWorkbook = Nothing
	Set objExcel = Nothing
	'updateCMEDatafile = "envName"
End Function



Function CME_Get_TC_Title()
	If Suite="CME_Automation" Then
		'Datafilepath =respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\"&respth(7)&"\"& Environment.Value("EnvironmentName") &"\"&respth(8)
		strTCtitle = respth(9)
		If right(strTCtitle,1)="s" Then
			strTCtitle=Replace(strTCtitle,".xls", "")
		Else 
			strTCtitle=Replace(strTCtitle,".xlsx", "")
		End If
	ElseIf Suite="End_to_End_Automation_Scripts" Then    
		Datafilepath =respth(0)&"\"&respth(1)&"\"&respth(2)&"\"&respth(3)&"\"&respth(4)&"\"&respth(5)&"\"&respth(6)&"\"&respth(7)&"\"&respth(8)
		ResultFile= respth(8)
		strTCtitle = respth(8)
		If right(strTCtitle,1)="s" Then
			strTCtitle=Replace(strTCtitle,".xls", "")
		Else 
			strTCtitle=Replace(strTCtitle,".xlsx", "")
		End If
		
	End If
	CME_Get_TC_Title = strTCtitle
End Function 


Function CME_FetchValueToGlobalVariable(Var, strVal)

	Const FOR_READING = 1 
	Const FOR_WRITING = 2 
	Const FOR_APPENDING = 8
	
	EnvVarsFile = "C:\Users\"& Environment.Value("UserName") &"\Documents\" & CME_Get_TC_Title & "_GlobalVariables.txt"
	strToAppend = Var & "=" & strVal

	Set fso=CreateObject("Scripting.FileSystemObject")
	If UCase(Trim(Win_Title_Field))="OVERRIDE_GLOBALVARIABLES" Then
		If fso.FileExists(EnvVarsFile) Then
			fso.DeleteFile(EnvVarsFile)
		End If
	End If 
''msgbox fso.FileExists(EnvVarsFile)
	If NOT fso.FileExists(EnvVarsFile) Then
			fso.CreateTextFile(EnvVarsFile)
	End If	
	
	set txtFileToRead=fso.OpenTextFile(EnvVarsFile, FOR_READING)
	If Not txtFileToRead.AtEndOfStream Then
		strContent = txtFileToRead.ReadAll
		txtFileToRead.Close
		arrTxtLines = Split(strContent, vbNewLine)
		set txtFileToWrite=fso.OpenTextFile(EnvVarsFile, FOR_WRITING)
		For iLn = 0 To UBound(arrTxtLines)
			
			If NOT InStr(arrTxtLines(iLn), Var&"=") > 0 Then
				txtFileToWrite.WriteLine arrTxtLines(iLn)
				
			End If
			
		Next
		txtFileToWrite.Close
	End If

	set txtFileToAppend=fso.OpenTextFile(EnvVarsFile, FOR_APPENDING)
	txtFileToAppend.WriteLine(strToAppend)
	txtFileToAppend.Close
	
	set txtFileToAppend=nothing
	set txtFileToWrite=nothing
	set txtFileToRead=nothing

End Function

Function CME_FetchValueFromGlobalVariable(value)


	EnvVarsFile = "C:\Users\"& Environment.Value("UserName") & "\Documents\" & CME_Get_TC_Title & "_GlobalVariables.txt"
	Set fso=CreateObject("Scripting.FileSystemObject")
	
	set txtFileToRead=fso.OpenTextFile(EnvVarsFile, 1)
	Do Until txtFileToRead.AtEndOfStream
	   Textline = txtFileToRead.Readline()
	
	   If Instr(Textline, value & "=") > 0 Then 
	      Textline = Split(Textline, "=")
	      CME_FetchValueFromGlobalVariable = Textline(1)
	      Exit Do 
	   End If
	
	
	Loop ' Read through every line
	
	set txtFileToRead=nothing

End Function


Function SendKeysSpace()
	Set objWsh=Createobject("Wscript.shell") 
	objWsh.SendKeys " "
	'CME_resPassed='CME_resPassed+1
	Set objWsh = Nothing
End Function


Sub RefreshPDFPage()
	Set nextTab = Browser("Creationtime:=1")
        
	If nextTab.Exist(15)=True Then
		nextTab.Sync
		wait 1
		If nextTab.Static("text:=Acrobat External Window","visible:=True").Exist(2) Then
			nextTab.highlight
			wait 3
			nextTab.Refresh
			nextTab.Sync
		End If

	End If
	
	Set nextTab = Nothing
End Sub

Function mmddyyyy(input)
    dim m: m = month(input)
    dim d: d = day(input)
    if (m < 10) then m = "0" & m
    if (d < 10) then d = "0" & d

    mmddyyyy = m & "/" & d & "/" & year(input)
End function



'****************************************************************
'Function name: Re_Rate_Borrower()
'Description: Re-Rates Borrower in Optimist
'Created by : Shruthi A
'Modified by and date:Muzaffar A & shruthi 
'****************************************************************

Function Re_Rate_Borrower()
	'Checkpoint for License Expired message
	Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
	Set okBtn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("devnamepath:=btnOk;notificationWindow;","slvtypename:=button","name:=btnOk","visible:=True","index:=0")
	If okBtn.Exist(1) Then
		okBtn.Click
	End If
	
	
	Set RiskTab = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=ContentControl","parent text:=Risk","visible:=True","index:=0") 'Risk Tab
	
	If RiskTab.Exist(20) Then
		'wait 1
		RiskTab.Highlight
		RiskTab.Click
		If win_title_field <> "" And ISnumeric(value)=True Then''' Modified by Shruthi for CSA PD overriding scenario
			Call LGDGrade_override()
		End If
		
		Set ReRate_Borr_btn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Re-Rate Borrower","visible:=True","index:=0")
		
		If ReRate_Borr_btn.Exist(20) Then
			'wait 1
			ReRate_Borr_btn.Highlight
			ReRate_Borr_btn.Click 'Clicking on Re-Rate Borrower button
			Set RiskAsmntTemp = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("parent text:=Risk Assessment Template Selection","visible:=True","index:=0")
			If RiskAsmntTemp.Exist(20) Then
				'Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=TextBlock","parent text:=.* - AgFast  \(2\.0\.0\)","visible:=True","index:=0").Click 'Selecting PLB-AgFast (2.0)
				Optimist_App.SlvWindow("slvtypename:=window").SlvObject("name:=content","text:=Select Template").SlvList("parent text:=Select Template", "slvtypename:=list view", "index:=0").Select 1
'				Optimist_App.SlvWindow("slvtypename:=window").SlvObject("name:=content","text:=Select Template").SlvList("parent text:=Select Template", "slvtypename:=list view", "index:=0").Select 2 ' Selecting the first template in the list
				
				wait 1
				Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=TextBlock","text:=.* \(12 Months, Historical\)","visible:=True","index:=0").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Start Assessment","visible:=True").Click    
				Set PerfRiskAsmnt = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("parent text:=Perform Risk Assessment","visible:=True","index:=0")
				If PerfRiskAsmnt.Exist(20) Then
'					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
'					wait 2
'					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
'					Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True").Click 'Selecting 6-Above Avearge radio button
'					wait 1
'					 Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
'					wait 1
'					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Finish","visible:=True").Click 'Clicking on Finish button
					
'					Set ddButton = Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","parent text:=Grade","visible:=True")
'                        ddButton.Highlight
'                        ddButton.Select "Legal Entity and Model" 'Selecting Legal Entity And Model from drop down
					Set mngmnt = Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True")
					loopCount = 0
					Do until mngmnt.Exist(1)
						If Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Exist(1) Then
							Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
						End If
						loopCount = loopCount + 1
						If loopCount = 7 Then
							Exit Do
						End If
					Loop 
					If mngmnt.Exist(1) Then
						mngmnt.Click
						wait 1
					 	Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					End if 
					
					Set mngmnt2 = Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=8 - New Borrower","visible:=True")
					wait 1
					If mngmnt2.Exist(1) Then
						mngmnt2.Click
						wait 1
					 	Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					End if 
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Finish","visible:=True").Click 'Clicking on Finish button
					Optimist_App.SlvWindow("slvtypename:=window").SlvCheckBox("slvtypename:=check box","text:=Override Grade","visible:=True").Set "ON"
					If value <> "" AND ISnumeric(value)=True Then''' Modified by Shruthi for CSA PD overriding scenario
						Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=0","visible:=True").Select value - 1
					Else 
						Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=0","visible:=True").Select 4
					End If
					Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=1","visible:=True").Select 0
					Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=2","visible:=True").Select "Model Only"
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Approve","visible:=True").Click 'Clicking on Approve button
					wait 5
					'Setting.WebPackage("ReplayType")=2
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","devnamepath:=;InnerTransformer;;OuterTransformer;C1TabItemPresenter;;tcLegalEntities;;;;content;;;","visible:=True","index:=0").Click 'Clicking on Save button
					'Setting.WebPackage("ReplayType")=1
					wait 5
	
		
				Else 
					Print "Perform Risk Assessment window not Found"
				End If
			Else 
				Print "Risk Assessment window not found"	
			End If
		Else 
			Print "Re-Rate button Not Found"
		End If
	Else 
		Print "Risk tab Not Found"
	End If
	
	
	Set PerfRiskAsmnt = Nothing
	Set RiskAsmntTemp = Nothing
	Set ReRate_Borr_btn = Nothing

End Function
'****************************************************************
'Function name: Re_Rate_Borrower_CFC()
'Description: Re-Rates Borrower in Optimist
'****************************************************************

Function Re_Rate_Borrower_CFC()
	Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
	
	'Checkpoint for License Expired message
	Set okBtn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("devnamepath:=btnOk;notificationWindow;","slvtypename:=button","name:=btnOk","visible:=True","index:=0")
	If okBtn.Exist(5) Then
		okBtn.Click
	End If
	
	
	
	Set RiskTab = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=ContentControl","parent text:=Risk","visible:=True","index:=0") 'Risk Tab
	
	If RiskTab.Exist(20) Then
		wait 1
		RiskTab.Highlight
		RiskTab.Click
		Set ReRate_Borr_btn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Re-Rate Borrower","visible:=True","index:=0")
		
		If ReRate_Borr_btn.Exist(20) Then
			wait 1
			ReRate_Borr_btn.Highlight
			ReRate_Borr_btn.Click 'Clicking on Re-Rate Borrower button
			Set RiskAsmntTemp = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("parent text:=Risk Assessment Template Selection","visible:=True","index:=0")
			If RiskAsmntTemp.Exist(20) Then
				 'Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=TextBlock","parent text:=CFC - Cash Crop/Grain Producer  \(3\.0\.0\)","visible:=True","index:=0").Click 'Selecting PLB-AgFast (2.0)
				 Optimist_App.SlvWindow("slvtypename:=window").SlvObject("name:=content","text:=Select Template").SlvList("parent text:=Select Template", "slvtypename:=list view", "index:=0").Select 1
				wait 1
				Optimist_App.SlvWindow("slvtypename:=window").SlvObject("slvtypename:=TextBlock","text:=.* \(12 Months, Historical\)","visible:=True","index:=0").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Start Assessment","visible:=True").Click    
				Set PerfRiskAsmnt = Optimist_App.SlvWindow("slvtypename:=window").SlvObject("parent text:=Perform Risk Assessment","visible:=True","index:=0")
				If PerfRiskAsmnt.Exist(20) Then
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True").Click 'Selecting 6-Above Avearge radio button
					wait 2
					 Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True").Click 'Selecting 6-Above Avearge radio button
					wait 2
					 Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True").Click 'Selecting 6-Above Avearge radio button
					wait 2
					 Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvRadioButton("slvtypename:=radio button","text:=5 - Strong","visible:=True").Click 'Selecting 6-Above Avearge radio button
					wait 2
					 Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Next","visible:=True").Click
					wait 2
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Finish","visible:=True").Click 'Clicking on Finish button
					
'					Set ddButton = Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","parent text:=Grade","visible:=True")
'                        ddButton.Highlight
'                        ddButton.Select "Legal Entity and Model" 'Selecting Legal Entity And Model from drop down
					wait 1
					Optimist_App.SlvWindow("slvtypename:=window").SlvCheckBox("slvtypename:=check box","text:=Override Grade","visible:=True").Set "ON"
					Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=0","visible:=True").Select 4
					Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=1","visible:=True").Select 0
					Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","index:=2","visible:=True").Select "Model Only"
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","text:=Approve","visible:=True").Click 'Clicking on Approve button
					wait 5
					Setting.WebPackage("ReplayType")=2
					Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","devnamepath:=;InnerTransformer;;OuterTransformer;C1TabItemPresenter;;tcLegalEntities;;;;content;;;","visible:=True","index:=0").Click 'Clicking on Save button
					Setting.WebPackage("ReplayType")=1
					wait 5
	
		
				Else 
					Print "Perform Risk Assessment window not Found"
				End If
			Else 
				Print "Risk Assessment window not found"	
			End If
		Else 
			Print "Re-Rate button Not Found"
		End If
	Else 
		Print "Risk tab Not Found"
	End If
	
	
	Set PerfRiskAsmnt = Nothing
	Set RiskAsmntTemp = Nothing
	Set ReRate_Borr_btn = Nothing

End Function


'****************************************************************
'Function name: LGDGrade_override()
'Description: LGD overides in Optimist
'Created by : Shruthi A
'****************************************************************

Function LGDGrade_override()
		
			Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
			Set Facility_rate = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=ContentControl","text:=Facility Rating","visible:=True","index:=0")
			If Facility_rate.Exist() Then
				Facility_rate.Click
				Set Max_btn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=CloseButton","parent text:=Statement","visible:=True","index:=0")
				Max_btn.highlight
				Max_btn.Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvLink("slvtypename:=HyperlinkButton","name:=btnLgdPopup","text:=0\.00","visible:=True","index:=0").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=btnOverrideLgdGrade","text:=Override LGD Grade","visible:=True","index:=0").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","name:=cbLgdGrades","visible:=True").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","name:=cbLgdGrades","visible:=True").SlvObject("slvtypename:=TextBlock","parent text:="&value,"visible:=True").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvEdit("slvtypename:=edit","name:=txtOverrideComment","visible:=True").set "test"
				Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=btnOverride","text:=Override","visible:=True","index:=0").Click
				wait 0.5
				'Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=CloseButton","parent text:=Statement","visible:=True","index:=0").Click
				Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=ContentControl","text:=Obligor Rating","visible:=True","index:=0").Click
				wait 0.5
			Else 
			Print "Facility Rate tab Not Found"
			End If
			
			Set Facility_rate=Nothing
			Set Max_btn=nothing
			
		End Function



'****************************************************************
'Description: Copies repository to Local C: drive from shared drive
Sub CME_CopyRepository()
	
	Set fso=CreateObject("Scripting.FileSystemObject")

	destFldr = "C:\Users\"& Environment.Value("UserName") & "\Documents\CME_Repository\"
	destFile = destFldr & "CME_object_repository.xlsx"
	If Not fso.FolderExists(destFldr) Then
		fso.CreateFolder(destFldr)
	End  If
	
	If fso.FileExists(destFile) Then
		fso.DeleteFile(destFile)
	End  If
	
	fso.CopyFile "\\nterprise.net\Bankdata\QA\CME_Automation\Repository\CME_object_repository.xlsx", destFldr, True
	
	 'fso.GetFile(destFile).Attributes = fso.GetFile(destFile).Attributes + 1
	
	Set fso=Nothing



End Sub


Sub CME_LoadingCircle()
	
	Set objLoading = CME_application.Image("file name:=\?_twr_=loadcircle\.gif","visible:=True")	
	Set objDialog = CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true")	
	Do while  objLoading.Exist(1)
		If objDialog.Exist(0.5) Then
			'CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true").Click
			Exit do 
		End If
		
	Loop		       
	Set objLoading = Nothing
	
	 If CME_application.WebElement("class:=label","html tag:=DIV","innertext:=System Exception","visible:=true").Exist(0.5) Then 'If Systemexception occurs take screenshot, report, exit test
			CME_application.WebElement("class:=button","attribute/fieldName:=Show Details >>","visible:=true").Click
			wait 1
			scrnShotTitle="SystemException"
			Call CaptureScreen(scrnShotTitle)
			Field = "SystemExceptionError"
			testdescription = "SystemExceptionError"
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 
		ElseIf CME_application.Image("html tag:=IMG","file name:=\?_twr_=error\.png","visible:=true").Exist(0.2) Then 'If Error occurs take screenshot, report, exit test
			scrnShotTitle="Error"
			Call CaptureScreen(scrnShotTitle)
			Field = "Error"
			testdescription = "Error"
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1

			On error goto 0
			Call CME_ExitTest() 
			
		ElseIf CME_application.WebElement("class:=label","html tag:=DIV","innertext:=Please fill in .*","visible:=true").Exist(0.2) Then 'When message: Please fill in a valid ... appears
		
			scrnShotTitle="DataMissing"
			Call CaptureScreen(scrnShotTitle)
			Field = "DataMissing"
			testdescription = CME_application.WebElement("class:=label","html tag:=DIV","innertext:=Please fill in .*","visible:=true").GetROProperty("Innertext")
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1

			On error goto 0
			Call CME_ExitTest() 		
		End If
		
	
	
End Sub
	

Sub CME_OBS_LoadingCircle()
	Set objLoading = CME_application.Image("file name:=\?_twr_=loadcircle\.gif","visible:=True")
	Set objDialog = CME_application.WebElement("html tag:=DIV","class:=dialog","visible:=true")	
	Do while  objLoading.Exist(1)
		
		If objDialog.Exist(1) Then
			CME_application.WebElement("attribute/tabindex:=0","attribute/fieldName:=OK","html tag:=A","visible:=true").Click
			'Exit do 
		End If
	Loop		       
	Set objDialog = nothing
	Set objLoading = Nothing
End Sub


Function CME_GetApplicationNumber()
	
	On error resume next
	Set objAppNum = CME_application.WebElement("html tag:=DIV", "attribute/fieldName:=Resize Panel", "index:=0", "visible:=True")
	If objAppNum.Exist(10) Then
		ArrAppNum = split(objAppNum.GetROProperty("innertext"), "Application #")
		environment.Value("CurrAppNum") = ArrAppNum(1)
		'ReportPassed(i)
	    'CME_resPassed='CME_resPassed+1
	Else 
		scrnShotTitle="ApplicationNumberPanel_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		On error goto 0
		Call CME_ExitTest()  
	End If
	Set objAppNum = Nothing

	CME_GetApplicationNumber = environment.Value("CurrAppNum")
	
End Function



Function CME_ExitTest()
	
	UpdateResultSheet(resPath)
	On error goto 0
	Exittest
End Function   



Function CME_GetApplicationNumber()
	Set objAppNum = CME_application.WebElement("html tag:=DIV", "attribute/fieldName:=Resize Panel", "index:=0", "visible:=True")
    If objAppNum.Exist(10) Then
    	ArrAppNum = split(objAppNum.GetROProperty("innertext"), "Application #")
    	environment.Value("CurrAppNum") = ArrAppNum(1)
    	'ReportPassed(i)
	    'CME_resPassed='CME_resPassed+1
    Else 
    	scrnShotTitle="ApplicationNumberPanel_Not_Found"
		Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		On error goto 0
		Call CME_ExitTest() 
    End If
    Set objAppNum = Nothing
End Function


Function CME_ClickButton(btnName, index)
	
	If index<>"" Then
    		indx = index
    	Else 
    		indx = 0
    End If
    	If Trim(LCase(Browser_Name)) = "chrome" Then
    		Set button=CME_application.Link("html tag:=A","innertext:=" & field,"visible:=true","index:=" & indx) 'Modified by Muzaffar A.
    		
    		
    	Else 	
    		Set button=CME_application.WebElement("html tag:=A","attribute/fieldName:=" & btnName,"visible:=true","index:=" & indx) 'Modified by Muzaffar A.
    		
   		End If
	  
	    BoolfieldExist=button.Exist(30)
	    If BoolfieldExist=True Then
	    	wait(1)
	    	'//Checking if button is enabled
	    	 
			enbFlg = False
			If button.Object.tabIndex = 0 Then
				enbFlg = True
			End If	
	    	
	    	If LCase(Trim(button.GetROProperty("class"))) <> LCase("floatDivLeft") Then
	    		If enbFlg = True Then
	    			'Setting.WebPackage("ReplayType") = 2
	    			button.click
	    			'Setting.WebPackage("ReplayType") = 1
	    		Else 
	    			scrnShotTitle=btnName&"Button_Disabled"
			    	Call CaptureScreen(scrnShotTitle)
					CME_ReportFailed(i)
					On error goto 0
					Call CME_ExitTest() 
	    		End If
	    	Else 
	    		'Setting.WebPackage("ReplayType") = 2
	    		button.click
	    		'Setting.WebPackage("ReplayType") = 1
	    	End If 
		    
			'wait 1		    
		    'CME_resPassed='CME_resPassed+1
		    Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
		Else 
			scrnShotTitle=field &"_Button_Not_Found"
	    	Call CaptureScreen(scrnShotTitle)
			CME_ReportFailed(i)
			CME_resFailed=CME_resFailed+1
			'CME_FetchResultStatusAndEnterinFinalResults(resPath)
'			On error goto 0
'			Exittest
		End If
		Set button=nothing
	
End Function



Function CloseAllBrowsersExceptCME()
	
	Dim oBrDes
	Dim oBrObjList
	Dim objIndex
	
	'Create Description Object with Browser class
	Set oBrDes=Description.Create
	oBrDes.Add "micclass","Browser"
	
	'Get Browser Objects from Desktop
	Set oBrObjList=Desktop.ChildObjects(oBrDes)
	
	'Use For Loop to close each browser
	'Use Count-1 because Object Indexing starts from "0"
	For objIndex=0 to oBrObjList.count-1
		'Verify the name of the browser is "cme-onboarding"
		If lcase(oBrObjList(objIndex).GetROproperty("name"))<>"cme-onboarding" then
			'Close the Browser
			oBrObjList(objIndex).close
		End If
	Next
	
	Set oBrObjList=Nothing
	Set oBrDes=Nothing
End Function



Function CME_GetReleaseInfo()
	
	CME_application.WebElement("class:=mainMenuButton","visible:=True","index:=0","innertext:=Help").Click
	CME_application.WebElement("class:=menuButtonText","visible:=True","index:=0","innertext:=About Credit Management Enterprise").Click
'	intRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=Release.*").GetROProperty("innertext")
'	intSQLRelease=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=SQL.*").GetROProperty("innertext")
	intPromotion=Browser("title:=.*").Page("title:=.*").WebElement("class:=label","visible:=True","index:=0","Innertext:=PROMOTIO.*").GetROProperty("innertext")
	
	
	CME_application.WebElement("html tag:=A","visible:=True","index:=0","innertext:=OK").Click
	
	Set objExcel = CreateObject("Excel.Application")
	Set objWorkbook = objExcel.Workbooks.Open(resPath)
	Set objWorksheet = objWorkbook.Worksheets(1)
	
	
	objWorksheet.Cells(2,1).Value="Environment URL:"
	objWorksheet.Cells(3,1).Value= "Promotion:"
	objWorksheet.Cells(2,2).Value = CME_application.GetROProperty("url")
	objWorksheet.Cells(3,2).Value= intPromotion
	
	objWorkbook.save
	objWorkbook.Application.Quit


	Set objWorksheet = Nothing
	Set objWorkbook = Nothing
	Set objExcel = Nothing
	
End Function

Function AngJS_Click_Btn(name, indx)
	If index<>"" Then
		indx = index
	Else 
		indx = 0
    End If
	set AngJSBtn = CME_application.WebButton("html tag:=BUTTON", "name:="& name, "visible:=True", "index:=0")

	If AngJSBtn.Exist(30) Then
		AngJSBtn.Click
		Reporter.ReportHtmlEvent micPass,field,testdescription&"( Step.No" & i+1 & " )"
	Else  
		scrnShotTitle=field &"_Button_Not_Found"
    	Call CaptureScreen(scrnShotTitle)
		CME_ReportFailed(i)
		CME_resFailed=CME_resFailed+1
		On error goto 0
		Call CME_ExitTest()
	End If

End Function

Sub CME_AngJS_LoadingWait()
	On error resume next
	Set objPlsWait = CME_application.WebElement("class:=click-blocker","html tag:=DIV","visible:=True","index:=0")
	tmr = 0
	Do while  objPlsWait.Exist(1)
		wait 1
		tmr = tmr + 1
		If tmr >= 600 Then
			scrnShotTitle="TimedOut"
			Call CaptureScreen(scrnShotTitle)
			Field = "Loading Took Long"
			testdescription = "Unexpected Event"
			CME_ReportFailed(i)
            CME_resFailed=CME_resFailed+1
			Call CME_ExitTest()
		End If
	Loop		       
	set objPlsWait=nothing
	
	'Set excErr = CME_application.WebElement("class:=font-data","html tag:=PRE","innertext:=An exception has occured in the application.*","visible:=True","index:=0")
	Set er = CME_application.WebElement("class:=modal-content","visible:=True","index:=0")
	If er.Exist(1) Then
		errMsgFlg = er.GetROProperty("innertext")
		If Instr(UCase(errMsgFlg), "ERROR") > 0 Then
			scrnShotTitle="Error"
			Call CaptureScreen(scrnShotTitle)
			Field = "Error"
			testdescription = "Error"
			CME_ReportFailed(i)
	        CME_resFailed=CME_resFailed+1
			On error goto 0
			Call CME_ExitTest() 
		End If 
		
	End If
	
	Set excErr = nothing

End Sub

'****************************************************************
'Function name: LGDGrade_override()
'Description: LGD overides in Optimist
'Created by : Shruthi A
'****************************************************************

Function LGDGrade_override()
		
	Set Optimist_App = Browser("title:=Ambit Optimist 8 - Business UI.*").Page("title:=Ambit Optimist 8 - Business UI.*")
	Set Facility_rate = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=ContentControl","text:=Facility Rating","visible:=True","index:=0")
	If Facility_rate.Exist() Then
		Facility_rate.Click
		Set Max_btn = Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=CloseButton","parent text:=Statement","visible:=True","index:=0")
		Max_btn.highlight
		Max_btn.Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvLink("slvtypename:=HyperlinkButton","name:=btnLgdPopup","text:=0\.00","visible:=True","index:=0").Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=btnOverrideLgdGrade","text:=Override LGD Grade","visible:=True","index:=0").Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","name:=cbLgdGrades","visible:=True").Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvComboBox("slvtypename:=combo box","name:=cbLgdGrades","visible:=True").SlvObject("slvtypename:=TextBlock","parent text:="&win_title_field,"visible:=True").Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvEdit("slvtypename:=edit","name:=txtOverrideComment","visible:=True").set "test"
		Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=btnOverride","text:=Override","visible:=True","index:=0").Click
		wait 0.5
		'Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=button","name:=CloseButton","parent text:=Statement","visible:=True","index:=0").Click
		Optimist_App.SlvWindow("slvtypename:=window").SlvButton("slvtypename:=ContentControl","text:=Obligor Rating","visible:=True","index:=0").Click
		wait 0.5
	Else 
	Print "Facility Rate tab Not Found"
	End If
	
	Set Facility_rate=Nothing
	Set Max_btn=nothing
	
End Function

Function CME_CSA_EntityInfo_RecScen()
	set activeScrn = CME_application.WebElement("html tag:=A", "innertext:=Entity Information.*", "index:=0")
		Set popUp = CME_application.Image("class:=image","file name:=\?_twr_=info\.png", "visible:=True","index:=0")
		Do while activeScrn.Exist(1)
			'Checking if Gender Selected
'			Set Male_RB=CME_application.WebElement("class:=radioButton","html tag:=A","attribute/fieldName:=ent_gender_M","visible:=true", "index:=0")
'			Set Female_RB=CME_application.WebElement("class:=radioButton","html tag:=A","attribute/fieldName:=ent_gender_F","visible:=true", "index:=0")
'			Male_RB_ChkFlag = Male_RB.GetROProperty("innerhtml")
'			Female_RB_ChkFlag = Male_RB.GetROProperty("innerhtml")
'			If Instr(Male_RB_ChkFlag, "_twr_=Radio_checkedDisabled.png")>0 Then
'			
'			End If

			Set objConnection = CreateObject("ADODB.Connection")
			Set objRecordSet = CreateObject("ADODB.Recordset")
			str_EnvName = Environment.Value("EnvironmentName")
			If str_EnvName = "FBLTRAIN" Or str_EnvName = "DATV" Then
			    objConnection.Open "provider=sqloledb;Server=" & str_EnvName & "be.nterprise.net; Database=FBCME;Trusted_Connection=Yes"
			ElseIf str_EnvName = "FBBUILD" Then
			     objConnection.Open "provider=sqloledb;Server=" & str_EnvName & "be.nterprise.net; Database=FBCME;Trusted_Connection=Yes"
			Else
				objConnection.open "provider=sqloledb;Server=" & str_EnvName & "BE.develop.fcbt; Database=FBCME;Trusted_Connection=Yes"
			End If
			
			
			custNum = CME_application.WebElement("class:=textField", "attribute/fieldName:=ent_obgr_num", "index:=0").WebEdit("html tag:=INPUT").GetROProperty("value")	
			strQry = "SELECT [ent_type], [ent_gender],[ent_mar_stat] FROM [FBCME].[dbo].[t_ccs_ent] e inner join t_ccs_ent_obligor_num_rel eor on eor.ent_id = e.ent_id where eor.[ent_obgr_num] = " &"'"& custNum &"'"
			objRecordSet.Open strQry, objConnection
			If objRecordSet.EOF = False Then
			        
			    ent_type = objRecordSet.Fields.Item(0)
			    ent_gender = objRecordSet.Fields.Item(1)
				ent_mar_stat = objRecordSet.Fields.Item(2)
			Else
			
			End If
			
			If UCase(Trim(ent_type)) = "I" Then
				'if Gender field not selected
				If IsNull(ent_gender) = True Then
					CME_application.WebElement("class:=radioButton","html tag:=A","attribute/fieldName:=ent_gender_M","visible:=true", "index:=0").Click
				End If
				'if Marital Status field is empty
				If IsNull(ent_mar_stat) = True Then
					set marSts = CME_application.WebElement("class:=dropDownGridBox","attribute/fieldName:=ENT_MAR_STAT_DESC").WebEdit("html tag:=INPUT","visible:=true", "index:=0")
					marSts.Click
					marSts.object.value = "Divorced"
					marSts.Click
					
				End If
				
			End If
			
			
			Set objConnection = Nothing
			Set objRecordSet = Nothing
		
		'
				'Checking if Primary Phone number field is empty
			Set phne = CME_application.WebElement("class:=textField", "attribute/fieldName:=ent_phn1", "index:=0").WebEdit("html tag:=INPUT")
			If phne.GetROProperty("value") = "" Then
				Randomize
				rndNum =  Int((9999999999 - 1000000000 + 1) * Rnd + 1000000000)
				phne.Set rndNum
			End If
			CME_application.WebElement("html tag:=A", "innertext:=Continue", "index:=0").Click
			Call CME_DynamicWait()
			
			Do While popUp.Exist(1)
				CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click
				Call CME_DynamicWait()
			Loop 
			Call CME_DynamicWait()
		Loop		       
'		Do While popUp.Exist(1)
'			CME_application.WebElement("html tag:=DIV", "class:=button", "innertext:=No", "visible:=true", "index:=0").Click
'			Call CME_DynamicWait()
'		Loop 

		
		
		Set popUp = Nothing
		set activeScrn = Nothing	
		Set phne = Nothing

End Function






