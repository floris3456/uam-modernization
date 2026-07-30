<#
.SYNOPSIS
    UAM & Device Master Hub - Enterprise Activity & Script Monitor
.VERSION
    39.20 (UDX table headers use UAM theme variables)
    Framework Version: 3.10 (Refactored LookupGrid to use New-UDXTableModular for server-side paging/sorting/filtering)
.DESCRIPTION
    - FIX: Harde browser freezes opgelost bij het openen van LookupGrids met duizenden records.
    - FEATURE: De LookupGrid modal gebruikt nu native de `New-UDXTableModular` engine. Dit zorgt direct voor Paging (standaard 5 rijen), Server-Side Sorting, en Server-Side Filtering (zoeken).
    - FIX: Harde parser crash ("The assignment expression is not valid") opgelost in de LookupGrid. 
    - FIX: RenderString omgebouwd naar single-quoted literals om premature `$null` evaluatie te voorkomen.
#>

# =========================================================================
# 1. MODULAIRE HELPERS VOOR DE TABEL ENGINE (V3.10)
# =========================================================================

$Script:UAMRoot = (Resolve-Path (Join-Path $PSScriptRoot '..\uam')).Path
$Script:UAMLocalModuleRoot = Join-Path $Script:UAMRoot '..\..\Modules\PSU_DD_Apps'
$Script:UAMLocalModulePath = Join-Path $Script:UAMLocalModuleRoot '1.0.0\PSU_DD_Apps.psd1'
if (Test-Path $Script:UAMLocalModulePath) {
    Import-Module $Script:UAMLocalModulePath -Force -ErrorAction Stop
}
else {
    Import-Module PSU_DD_Apps -Force -ErrorAction Stop
}

if (-not (Get-Command New-UDXTableModular -ErrorAction SilentlyContinue)) {
    throw 'New-UDXTableModular kon niet worden geladen. Controleer de PSU_DD_Apps module in Repository\Modules.'
}

# =========================================================================
# 2. MASTER DASHBOARD INTEGRATIE (MET GEMERGED DATA DICTIONARY)
# =========================================================================
. (Join-Path $Script:UAMRoot 'config\Settings.ps1')
. (Join-Path $Script:UAMRoot 'config\DataDictionary.ps1')
$Script:UAMDataDictionarySqlPath = Join-Path $Script:UAMRoot 'config\DataDictionarySql.ps1'
if (Test-Path $Script:UAMDataDictionarySqlPath) {
    . $Script:UAMDataDictionarySqlPath
    try {
        [void](Update-UAMDataDictionaryFromSql -Dictionary $Global:DataDictionary -SqlInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase)
    }
    catch {
        $Global:DataDictionarySource = 'FileFallback'
        $Global:DataDictionaryLoadError = $_.Exception.Message
    }
}
. (Join-Path $Script:UAMRoot 'components\platform\New-UAMPlatformShell.ps1')


New-UDApp -Title "UAM Activity Monitor" -Content { 

    # --- CENTRALE CSS ---
    [string]$TechCSS = @"
$(Get-UAMPlatformCss)
    @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');
    .uam-background { background-color: var(--uam-bg); min-height: 100vh; padding: 20px; font-family: 'Inter', sans-serif; }
    .uam-card { background-color: var(--uam-surface); border-radius: 6px; box-shadow: var(--uam-shadow); border-top: 4px solid var(--uam-primary-strong); overflow: hidden; }
    .uam-top-bar { display: flex; justify-content: space-between; align-items: center; padding: 20px 25px; border-bottom: 1px solid var(--uam-border); background-color: var(--uam-surface-soft); }
    .uam-logo-text { font-size: 22px; font-weight: 700; color: var(--uam-text); }
    .tab-content-wrapper { padding: 25px; }
    .uam-sticky-table .MuiTableContainer-root, .uam-am-sticky-table .MuiTableContainer-root { overflow: auto !important; }
    .uam-sticky-table .MuiTable-root, .uam-am-sticky-table .MuiTable-root { border-collapse: separate !important; }
    .uam-sticky-table .MuiTableHead-root, .uam-am-sticky-table .MuiTableHead-root { background: var(--uam-table-header-bg) !important; }
    .uam-sticky-table .MuiTableCell-stickyHeader, .uam-am-sticky-table .MuiTableCell-stickyHeader, .uam-sticky-table thead th, .uam-am-sticky-table thead th { position: sticky !important; top: 0 !important; z-index: 30 !important; background: var(--uam-table-header-bg) !important; box-shadow: inset 0 -1px 0 var(--uam-border) !important; }
    .table-section-title { color: var(--uam-text) !important; margin-bottom: 15px !important; padding-left: 10px !important; border-left: 4px solid var(--uam-primary-strong); font-weight: 600 !important; background-color: var(--uam-surface-soft); padding: 8px 10px; border-radius: 0 4px 4px 0; }
    
    /* UI Organogram */
    .selected-oe-display { font-weight: 600; color: var(--uam-primary-strong); border-left: 2px solid var(--uam-border); padding-left: 15px; margin-left: 10px; font-size: 1rem; display: inline-flex; align-items: center; height: 36px; }
    .modern-modal-header { display: flex; justify-content: space-between; align-items: center; padding-bottom: 15px; border-bottom: 1px solid var(--uam-border); margin-bottom: 20px; font-size: 1.25rem; font-weight: 700; color: var(--uam-text); }
    .modern-modal-header.uam-draggable-modal-header { box-sizing: border-box; width: 100%; min-height: 48px; margin: 0; padding: 0 0 0 16px; border: 0 !important; border-bottom: 1px solid #004f9e !important; border-radius: 7px 7px 0 0; background: #005fb8 !important; box-shadow: inset 0 1px 0 rgba(255,255,255,0.16), 0 1px 3px rgba(0,0,0,0.28); color: #ffffff !important; cursor: move; cursor: grab; user-select: none; touch-action: none; }
    .uam-draggable-modal-header:active { cursor: grabbing; }
    .uam-modal-window-title { display: flex; align-items: center; gap: 10px; min-width: 0; color: #ffffff; font-size: 0.95rem; font-weight: 600; pointer-events: none; }
    .uam-modal-window-title > span { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    .uam-modal-window-controls { display: flex; align-items: stretch; align-self: stretch; margin-left: auto; }
    .uam-modal-drag-hint { display: inline-flex; align-items: center; gap: 8px; padding: 0 14px; color: rgba(255,255,255,0.82); font-size: 0.74rem; font-weight: 500; letter-spacing: 0.01em; pointer-events: none; }
    .uam-modal-drag-grip { width: 18px; height: 14px; background-image: radial-gradient(circle, currentColor 1.4px, transparent 1.6px); background-position: 0 0; background-size: 6px 6px; opacity: 0.9; }
    .uam-modal-window-close { display: flex; align-items: stretch; }
    .uam-background .uam-modal-window-close button, .uam-background .uam-modal-window-close .MuiButton-root { min-width: 48px !important; width: 48px; height: 48px; padding: 0 !important; border-radius: 0 7px 0 0 !important; background: transparent !important; box-shadow: none !important; color: #ffffff !important; cursor: pointer; }
    .uam-background .uam-modal-window-close button:hover, .uam-background .uam-modal-window-close .MuiButton-root:hover { background-color: #c42b1c !important; color: #ffffff !important; }
    @media (max-width: 700px) { .uam-modal-drag-hint span { display: none; } .uam-modal-drag-hint { padding: 0 10px; } }
    .modern-card-container { padding: 30px; background-color: var(--uam-surface); height: 100%; color: var(--uam-text); }
    .uam-hidden-bridge { display: none !important; position: absolute; left: -9999px; }

    /* Overlay knoppen & zoekbalk */
    .float-btns { position: absolute; top: 15px; right: 15px; z-index: 100; display: flex; flex-direction: column; gap: 8px; }
    .float-btns button { background: #0f172a; color: white; border: none; padding: 10px 15px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: 600; min-width: 140px; box-shadow: 0 2px 4px rgba(0,0,0,0.2); transition: 0.2s; }
    .float-btns button:hover { background: #1e293b; }
    .float-btns .btn-accent { background: #0078D4; }
    .float-btns .btn-accent:hover { background: #005a9e; }
    
    .search-box { padding: 10px 15px; border-radius: 4px; border: 1px solid var(--uam-border); font-family: 'Inter', sans-serif; font-size: 13px; outline: none; box-shadow: var(--uam-shadow); width: 250px; }
    .search-box:focus { border-color: #0078D4; }
    
    /* Config Panel */
    .vis-configuration-wrapper { width: 100%; font-family: 'Inter', sans-serif; font-size: 12px; }
    .vis-config-header { font-weight: bold; margin-bottom: 10px; font-size: 14px; border-bottom: 1px solid var(--uam-border); padding-bottom: 5px; }
"@

    New-UDStyle -Style $TechCSS -Content {
        New-UAMThemeSync
        Invoke-UDJavaScript -JavaScript @'
(function () {
    if (window.__uamDraggableModalInstalled) return;
    window.__uamDraggableModalInstalled = true;

    let dragState = null;
    const interactiveSelector = 'button, a, input, textarea, select, [role="button"]';
    const clamp = (value, minimum, maximum) => Math.min(Math.max(value, minimum), maximum);

    document.addEventListener('pointerdown', function (event) {
        if (!event.target.closest || event.target.closest(interactiveSelector)) return;

        const header = event.target.closest('.uam-draggable-modal-header');
        let paper = header && (header.closest('.MuiDialog-paper') || header.closest('[role="dialog"]'));

        // Also accept the very top edge of the dialog. This keeps the window
        // draggable if PSU or Material UI inserts a few pixels around the bar.
        if (!paper) {
            paper = event.target.closest('.MuiDialog-paper') || event.target.closest('[role="dialog"]');
            if (!paper || !paper.querySelector('.uam-draggable-modal-header')) return;
            const paperRect = paper.getBoundingClientRect();
            if (event.clientY > paperRect.top + 50) return;
        }

        const rect = paper.getBoundingClientRect();
        paper.dataset.uamDraggable = 'true';
        Object.assign(paper.style, {
            position: 'fixed',
            left: rect.left + 'px',
            top: rect.top + 'px',
            right: 'auto',
            bottom: 'auto',
            margin: '0',
            width: rect.width + 'px',
            transform: 'none'
        });

        dragState = {
            paper: paper,
            pointerId: event.pointerId,
            offsetX: event.clientX - rect.left,
            offsetY: event.clientY - rect.top
        };

        if (header && header.setPointerCapture) header.setPointerCapture(event.pointerId);
        event.preventDefault();
    });

    document.addEventListener('pointermove', function (event) {
        if (!dragState || event.pointerId !== dragState.pointerId) return;

        const rect = dragState.paper.getBoundingClientRect();
        const maximumX = Math.max(0, window.innerWidth - rect.width);
        const maximumY = Math.max(0, window.innerHeight - rect.height);
        const left = clamp(event.clientX - dragState.offsetX, 0, maximumX);
        const top = clamp(event.clientY - dragState.offsetY, 0, maximumY);

        dragState.paper.style.left = left + 'px';
        dragState.paper.style.top = top + 'px';
        event.preventDefault();
    }, { passive: false });

    const stopDragging = function (event) {
        if (dragState && (!event || event.pointerId === dragState.pointerId)) dragState = null;
    };
    document.addEventListener('pointerup', stopDragging);
    document.addEventListener('pointercancel', stopDragging);

    window.addEventListener('resize', function () {
        document.querySelectorAll('.MuiDialog-paper[data-uam-draggable="true"]').forEach(function (paper) {
            const rect = paper.getBoundingClientRect();
            paper.style.left = clamp(rect.left, 0, Math.max(0, window.innerWidth - rect.width)) + 'px';
            paper.style.top = clamp(rect.top, 0, Math.max(0, window.innerHeight - rect.height)) + 'px';
        });
    });
})();
'@
        New-UDElement -Tag 'div' -Attributes @{ className = 'uam-platform-shell' } -Content {
            New-UAMPlatformNav -ActiveKey 'logging'
            New-UDElement -Tag 'main' -Attributes @{ className = 'uam-platform-main' } -Content {
                New-UDElement -Tag 'div' -Attributes @{ className = 'uam-background' } -Content {
                    New-UDElement -Tag 'div' -Attributes @{ className = 'uam-card' } -Content {
                
                # --- HEADER ---
                New-UDElement -Tag 'div' -Attributes @{ className = 'uam-top-bar' } -Content {
                    New-UDElement -Tag 'div' -Attributes @{ className = 'uam-title-group' } -Content {
                        New-UDIcon -Icon ShieldAlt -Color '#0078D4' -Size '2x'
                        New-UDElement -Tag 'span' -Attributes @{ className = 'uam-logo-text' } -Content { "UAM Activity Monitor" }
                    }
                    New-UDDynamic -Id "UAM_Clock" -AutoRefresh -AutoRefreshInterval 60 -Content {
                        New-UDTypography -Text (Get-Date -Format "dd MMMM yyyy HH:mm")
                    }
                }

                # --- HOOFD TABBLADEN ---
                New-UDTabs -Tabs {

                    # ==========================================
                    # TAB 1: UAM LOGGING USERS
                    # ==========================================
                    New-UDTab -Text "Logging Users" -Icon (New-UDIcon -Icon Users) -Content {
                        New-UDElement -Tag 'div' -Attributes @{ className = 'tab-content-wrapper' } -Content {
                            New-UDTabs -Tabs {

                                # Sub-Tab 1: User Grids
                                New-UDTab -Text "User Grids" -Icon (New-UDIcon -Icon Table) -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        New-UDStack -Direction column -Spacing 6 -Content {

                                            # Tabel 1: Device Logging Users
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Device Logging Users" -Variant "h6" -ClassName "table-section-title"

                                                [string]$Query1 = @"
SELECT 
	StartLogging
	,DL_APP_UAM_TAT_member = CAST(IIF(adu_member_DL_APP_UAM_TAT.UserName IS NULL, 0,1) AS BIT)
    ,BRON = CASE WHEN yf_emp.personCode IS NOT NULL THEN 'GG - YF' WHEN afas_empl.Persoonsnummer IS NOT NULL THEN 'WIJ - AFAS' ELSE 'AD' END
	,Afdeling = CASE WHEN yf_emp.personCode IS NOT NULL THEN yf_emp.organizationUnitName WHEN afas_empl.Persoonsnummer IS NOT NULL THEN afas_empl.Organisatorische_eenheid_omschrijving ELSE adu.Department END
	,AfdCode = CASE WHEN yf_emp.personCode IS NOT NULL THEN yf_emp.organizationUnitCode WHEN afas_empl.Persoonsnummer IS NOT NULL THEN afas_empl.Organisatorische_eenheid_code ELSE '??' END
	,Functie = CASE WHEN yf_emp.personCode IS NOT NULL THEN yg_emp_roepnaamfunctie.[description] WHEN afas_empl.Persoonsnummer IS NOT NULL THEN afas_empl.Functie_omschrijving ELSE adu.Title END
	,FuncCode = CASE WHEN yf_emp.personCode IS NOT NULL THEN yg_emp_roepnaamfunctie.value WHEN afas_empl.Persoonsnummer IS NOT NULL THEN afas_empl.Functie_code ELSE '??' END
	,dlu.UserName
	,Computername
	,NonpersistentComputer
	,LatestActivity_HoursAgo = DateDIFF(hour,LatestActivity.[MaxDate],GETDATE())
	,UAMVersion
    ,UAMInstallDate
	,UAMprocessMaxMemoryMB
	,dlu.WhenCreated
	,LoggingUserID
FROM  [dbo].[DeviceLoggingUsers] dlu WITH (NOLOCK) 
	LEFT JOIN [dbo].AdUsers adu WITH (NOLOCK) ON adu.samaccountname = dlu.username 
	LEFT JOIN [dbo].GG_YF_Employments yf_emp WITH (NOLOCK) ON '01-' + yf_emp.personCode = adu.EmployeeNumber AND (yf_emp.dischargeDate IS NULL OR yf_emp.dischargeDate > getdate()) 
	LEFT JOIN [dbo].[GG_YF_EmploymentsExtensions] yg_emp_roepnaamfunctie WITH (NOLOCK) ON yg_emp_roepnaamfunctie.bo4FieldCode = 'E00420' AND yg_emp_roepnaamfunctie.personCode = yf_emp.personCode AND yg_emp_roepnaamfunctie.employmentCode = yf_emp.employmentCode 
	LEFT JOIN [dbo].[WIJ_AFAS_Employments] afas_empl WITH (NOLOCK) ON '03-' + afas_empl.Persoonsnummer = adu.EmployeeNumber AND (dischargeDate IS NULL OR dischargeDate > GETDATE())
	LEFT JOIN [dbo].[DeviceLoggingUserAdGroupMembers] adu_member_DL_APP_UAM_TAT WITH (NOLOCK)  ON adu_member_DL_APP_UAM_TAT.[UserName]= adu.SamAccountName AND ADGroup_ObjectGuid = 'CDAE20C0-05E8-4323-83C6-F6BF40635BAC'
		CROSS APPLY (
			SELECT MAX(d) AS [MaxDate]
			FROM (VALUES 
				([LastWindowsProcessesLogDateTime]),
				([LastRecentFilesLogDateTime]),
				([LastBrowserEdgeLogDateTime]),
				([LastBrowserFireFoxLogDateTime]),
				([LastBrowserChromeLogDateTime])
			) AS AllDates(d)
		) AS LatestActivity
"@
                                                $Device_Logging_Users_CustCols = @( 
                                                    @{
                                                        Property = 'StartLogging'
                                                        Title = 'Logging Actief'
                                                        Position = 0
                                                        Render = {
                                                            [bool]$IsActive = $false
                                                            [string]$Val = [string]($EventData.StartLogging)
                                                            if ($Val -match 'True|1' -or $EventData.StartLogging -eq $true) { $IsActive = $true }
                                                            
                                                            if ($IsActive) { New-UDIcon -Icon 'CheckSquare' -Color '#10b981' -Size 'lg' } 
                                                            else { New-UDIcon -Icon 'Square' -Color '#cbd5e1' -Size 'lg' }
                                                        }
                                                    }
                                                    @{
                                                        Property = 'DL_APP_UAM_TAT_member'
                                                        Title = 'DL_APP_UAM_TAT_member'
                                                        Position = 0
                                                        Render = {
                                                            [bool]$IsActive = $false
                                                            [string]$Val = [string]($EventData.DL_APP_UAM_TAT_member)
                                                            if ($Val -match 'True|1' -or $EventData.DL_APP_UAM_TAT_member -eq $true) { $IsActive = $true }
                                                            
                                                            if ($IsActive) { New-UDIcon -Icon 'CheckSquare' -Color '#10b981' -Size 'lg' } 
                                                            else { New-UDIcon -Icon 'Square' -Color '#cbd5e1' -Size 'lg' }
                                                        }
                                                    }
                                                    @{
                                                        Property = 'NonpersistentComputer'
                                                        Title = 'Nonpersistent Computer'
                                                        Position = 0
                                                        Render = {
                                                            [bool]$IsActive = $false
                                                            [string]$Val = [string]($EventData.NonpersistentComputer)
                                                            if ($Val -match 'True|1' -or $EventData.NonpersistentComputer -eq $true) { $IsActive = $true }
                                                            
                                                            if ($IsActive) { New-UDIcon -Icon 'CheckSquare' -Color '#10b981' -Size 'lg' } 
                                                            else { New-UDIcon -Icon 'Square' -Color '#cbd5e1' -Size 'lg' }
                                                        }
                                                    }


                                                )
                                                $Device_Logging_Users_BulkActions = @(
                                                    @{
                                                        Name = 'Start Logging: AAN'
                                                        Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "BEVESTIGD: Alle records worden op de achtergrond geactiveerd!" -BackgroundColor "#10b981" -Duration 10000
                                                                Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query "UPDATE [dbo].[DeviceLoggingUsers] SET StartLogging = 1" -ErrorAction Stop
                                                            } else {
                                                                [array]$IDs = $SelectedRows | Select-Object -ExpandProperty LoggingUserID
                                                                if ($IDs.Count -gt 0) {
                                                                    [string]$InClause = ($IDs | ForEach-Object { "'$_'" }) -join ','
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query "UPDATE [dbo].[DeviceLoggingUsers] SET StartLogging = 1 WHERE LoggingUserID IN ($InClause)" -ErrorAction Stop
                                                                    Show-UDToast -Message "$($IDs.Count) gebruikers geactiveerd." -BackgroundColor '#10b981'
                                                                }
                                                            }
                                                        }
                                                    },
                                                    @{
                                                        Name = 'Start Logging: UIT'
                                                        Icon = (New-UDIcon -Icon 'Stop' -Color '#f59e0b')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "BEVESTIGD: Alle records worden op de achtergrond gedeactiveerd!" -BackgroundColor "#f59e0b" -Duration 10000
                                                                Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query "UPDATE [dbo].[DeviceLoggingUsers] SET StartLogging = 0" -ErrorAction Stop
                                                            } else {
                                                                [array]$IDs = $SelectedRows | Select-Object -ExpandProperty LoggingUserID
                                                                if ($IDs.Count -gt 0) {
                                                                    [string]$InClause = ($IDs | ForEach-Object { "'$_'" }) -join ','
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query "UPDATE [dbo].[DeviceLoggingUsers] SET StartLogging = 0 WHERE LoggingUserID IN ($InClause)" -ErrorAction Stop
                                                                    Show-UDToast -Message "$($IDs.Count) gebruikers gedeactiveerd." -BackgroundColor '#f59e0b'
                                                                }
                                                            }
                                                        }
                                                    },
                                                    @{
                                                        Name = 'Geselecteerde Verwijderen'
                                                        Icon = (New-UDIcon -Icon 'Trash' -Color '#ef4444')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            
                                                            # Veiligheidsmechanisme: Blokkeer het weggooien van de volledige tabel via 'Actie op ALLES'
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "Veiligheidswaarschuwing: Bulk verwijderen van ALLES via deze knop is geblokkeerd." -BackgroundColor "#ef4444" -Duration 8000
                                                            } else {
                                                                [int]$SuccesCount = 0
                                                                
                                                                # Loop door elk geselecteerd record heen
                                                                foreach ($Row in $SelectedRows) {
                                                                    [string]$Id = $Row.LoggingUserID
                                                                    if (-not [string]::IsNullOrWhiteSpace($Id)) {
                                                                        
                                                                        # 1. Verwijder uit database
                                                                        Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query "DELETE FROM [dbo].[DeviceLoggingUsers] WHERE LoggingUserID = '$Id'" -ErrorAction Stop
                                                                        
                                                                        # 2. Schrijf de volledige rij-data naar de ActionLog
                                                                        try {
                                                                            [string]$ActionUser = if ($null -ne $User) { $User } else { 'System' }
                                                                            [string]$DelJson = $Row | ConvertTo-Json -Compress -Depth 5
                                                                            [string]$SafeDelJson = [string]$DelJson -replace "'", "''"
                                                                            [string]$LogQuery = "INSERT INTO [ActionLog] ([ActionType], [TableName], [RecordID], [ChangedFields], [UserName], [Timestamp]) VALUES ('Verwijderen', 'DeviceLoggingUsers', '$Id', '$SafeDelJson', '$ActionUser', GETDATE())"
                                                                            Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $LogQuery -ErrorAction SilentlyContinue
                                                                        } catch {}
                                                                        
                                                                        $SuccesCount++
                                                                    }
                                                                }
                                                                Show-UDToast -Message "$SuccesCount records succesvol verwijderd en gelogd." -BackgroundColor '#10b981'
                                                            }
                                                        }
                                                    }
                                                )
                                                New-UDXTableModular -SqlInstance $Global:UAMSqlInstance -DatabaseName $Global:UAMDatabase -TableName "DeviceLoggingUsers" -PrimaryKey 'LoggingUserID' -SqlQuery $Query1 -ShowDeleteButton $true -ShowAddButton $false -ShowEditButton $false -CustomColumns $Device_Logging_Users_CustCols -CustomActions $Device_Logging_Users_BulkActions -EnableMultiSelect $true
                                            }

                                            # Tabel 2: HR Personeel
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "HR Personeel & UAM Status (Actueel)" -Variant "h6" -ClassName "table-section-title"
                                                [string]$HrUamQuery = @"
SELECT
    hr.Persoonsnummer,
    DL_APP_UAM_TAT_member = CAST(IIF(tat.UserName IS NULL, 0, 1) AS bit),
    hr.Email,
    hr.SamAccountName,
    hr.CodeOrganisatorischeEenheid,
    hr.NaamOrganisatorischeEenheid,
    hr.RoepnaamFunctie,
    hr.RoepnaamFunctieCode,
    hr.Afdeling,
    hr.DatumInDienst,
    hr.DatumUitDienst,
    hr.EmailLeidinggevende,
    hr.StatusDienstverband,
    hr.Laaddatum,
    dlu.Computers_Logged,
    dlu.Lasttime_UAM_Started
FROM (
    SELECT DISTINCT
        src.Persoonsnummer,
        Email = COALESCE(src.EmailHr, NULLIF(aduSam.EmailAddress, ''), NULLIF(aduSam.mail, ''), NULLIF(aduEmp.EmailAddress, ''), NULLIF(aduEmp.mail, '')),
        SamAccountName = COALESCE(src.SamAccountNameHr, NULLIF(aduEmp.SamAccountName, ''), NULLIF(aduSam.SamAccountName, '')),
        src.CodeOrganisatorischeEenheid,
        src.NaamOrganisatorischeEenheid,
        src.RoepnaamFunctie,
        src.RoepnaamFunctieCode,
        src.Afdeling,
        src.DatumInDienst,
        src.DatumUitDienst,
        src.EmailLeidinggevende,
        src.StatusDienstverband,
        src.Laaddatum
    FROM (
        SELECT DISTINCT
            [Persoonsnummer] = CASE
                WHEN NULLIF(yf.personeelsnr, '') IS NULL THEN NULL
                WHEN yf.personeelsnr LIKE '[0-9][0-9]-%' THEN yf.personeelsnr
                WHEN NULLIF(yf.company, '') IS NOT NULL THEN yf.company + '-' + yf.personeelsnr
                ELSE '01-' + yf.personeelsnr
            END,
            [PersonKey] = CASE
                WHEN NULLIF(yf.personeelsnr, '') IS NULL THEN NULL
                WHEN yf.personeelsnr LIKE '[0-9][0-9]-%' THEN yf.personeelsnr
                WHEN NULLIF(yf.company, '') IS NOT NULL THEN yf.company + '-' + yf.personeelsnr
                ELSE '01-' + yf.personeelsnr
            END,
            [EmailHr] = NULLIF(yf.ad_email, ''),
            [SamAccountNameHr] = NULLIF(yf.SamAccountName, ''),
            [CodeOrganisatorischeEenheid] = yf.Organisatorische_eenheid_code,
            [NaamOrganisatorischeEenheid] = yf.Organisatorische_eenheid_omschrijving,
            [RoepnaamFunctie] = yf.functie_omschrijving,
            [RoepnaamFunctieCode] = yf.Functie_code,
            [Afdeling] = yf.Organisatorische_eenheid_omschrijving,
            [DatumInDienst] = yf.Begindatum_contract,
            [DatumUitDienst] = yf.Einddatum_contract,
            [EmailLeidinggevende] = CAST(NULL AS varchar(320)),
            [StatusDienstverband] = yf.Status_Contract,
            [Laaddatum] = COALESCE(yf.contracts_import_data, yf.contracts_first_imported)
        FROM dbo.vwt_hr_contracts yf WITH (NOLOCK)
        WHERE (UPPER(ISNULL(yf.Status_Contract, '')) LIKE 'ACTUEEL%' OR UPPER(ISNULL(yf.Status_Contract, '')) LIKE '%ACTIEF%')
    ) src
    LEFT JOIN dbo.AdUsers aduSam WITH (NOLOCK)
        ON aduSam.SamAccountName = src.SamAccountNameHr
    LEFT JOIN dbo.AdUsers aduEmp WITH (NOLOCK)
        ON aduEmp.EmployeeNumber = src.PersonKey
) hr
LEFT JOIN (
    SELECT
        UserName = dlu2.UserName,
        Computers_Logged = STRING_AGG(dlu2.Computername, ' ; '),
        Lasttime_UAM_Started = MAX(dlu2.LastLogon)
    FROM dbo.DeviceLoggingUsers dlu2 WITH (NOLOCK)
    WHERE NULLIF(dlu2.UserName, '') IS NOT NULL
    GROUP BY dlu2.UserName
) dlu ON dlu.UserName = hr.SamAccountName
LEFT JOIN (
    SELECT DISTINCT UserName
    FROM dbo.DeviceLoggingUserAdGroupMembers WITH (NOLOCK)
    WHERE ADGroup_ObjectGuid = 'CDAE20C0-05E8-4323-83C6-F6BF40635BAC'
) tat ON tat.UserName = hr.SamAccountName
"@

                                                $Employees_CustCols = @(
                                                    @{
                                                        Property = 'DL_APP_UAM_TAT_member'
                                                        Title = 'DL_APP_UAM_TAT_member'
                                                        Position = 0
                                                        Render = {
                                                            [bool]$IsActive = $false
                                                            [string]$Val = [string]($EventData.DL_APP_UAM_TAT_member)
                                                            if ($Val -match 'True|1' -or $EventData.DL_APP_UAM_TAT_member -eq $true) { $IsActive = $true }
                                                            
                                                            if ($IsActive) { New-UDIcon -Icon 'CheckSquare' -Color '#10b981' -Size 'lg' } 
                                                            else { New-UDIcon -Icon 'Square' -Color '#cbd5e1' -Size 'lg' }
                                                        }
                                                    }
                                                )


$Employees_BulkActions = @(
                                                @{
                                                    Name = 'Lid maken AD groep om te gaan Loggen'
                                                    Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                    Callback = {
                                                        param([array]$SelectedRows)
                                                        if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                            Show-UDToast -Message "Is niet toegestaan voor deze Actie!" -BackgroundColor "#10b981" -Duration 10000
                                                        } else {
                                                            # FIX: Verander LoggingUserID naar SamAccountName!
                                                            [array]$IDs = $SelectedRows | Select-Object -ExpandProperty SamAccountName
                                                            
                                                            if ($IDs.Count -gt 0) {
                                                                foreach ($SelectedRow in $SelectedRows) {} # Deze lege loop doet niks, maar stoort ook niet
                                                                try {
                                                                    # 1. Haal de credential op uit de PSU Vault (pas de naam aan indien nodig)
                                                                    $AdCred = $Secret:SVC_psu_job1
                                                                    
                                                                    ## 2. Definieer je Domain Controller (Vaak vereist als je -Credential gebruikt)
                                                                    $domain = [System.DirectoryServices.ActiveDirectory.Domain]::GetCurrentDomain()
                                                                    [string]$DomainController = $domain.PdcRoleOwner.Name
                                                                    
                                                                    # 3. Voer het commando in BULK uit (-Members accepteert direct de array met namen)
                                                                    $Ids | ForEach-Object {
                                                                        # We gebruiken nu de $_ variabele, wat de SamAccountName is!
                                                                        Add-ADGroupMember -Identity "DL_APP_UAM_TAT" -Members $_ -Server $DomainController -Credential $AdCred -Confirm:$false -ErrorAction Stop 
                                                                        $Sql_Add_DeviceLoggingUserAdGroupMembers = "INSERT INTO [dbo].[DeviceLoggingUserAdGroupMembers] ([UserName],[AdUser_ObjectGuid],[AdGroup_ObjectGuid]) SELECT '$_',NULL,'CDAE20C0-05E8-4323-83C6-F6BF40635BAC'"
                                                                        Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $Sql_Add_DeviceLoggingUserAdGroupMembers -ErrorAction SilentlyContinue
                                                                     }
                                                                    
                                                                    Show-UDToast -Message "$($IDs.Count) gebruikers toegevoegd aan de AD groep." -BackgroundColor '#10b981'
                                                                } catch {
                                                                    Show-UDToast -Message "AD Fout: $($_.Exception.Message)" -BackgroundColor '#ef4444' -Duration 10000
                                                                }
                                                            } else {
                                                                # Extra feedback ingebouwd voor als er tóch weer een property fout gespeld is
                                                                Show-UDToast -Message "Fout: Kon geen 'SamAccountName' in de selectie vinden." -BackgroundColor '#f59e0b'
                                                            }
                                                        }
                                                    }
                                                }
                                            )

                                            New-UDXTableModular -SqlInstance $Global:UAMSqlInstance -DatabaseName $Global:UAMDatabase -PrimaryKey 'Persoonsnummer' -SqlQuery $HrUamQuery -DefaultSortColumn "Computers_Logged" -DefaultSortDirection "DESC" -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false -CustomActions $Employees_BulkActions -EnableMultiSelect $true -CustomColumns  $Employees_CustCols

                                            }
                                        }
                                    }
                                }

                                # Sub-Tab 2: Organogram
                                New-UDTab -Text "Organogram" -Icon (New-UDIcon -Icon Sitemap) -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        
                                        if ($null -eq $Session:RootOE) { [string]$Session:RootOE = "HOE" }

                                        New-UDCard -Elevation 0 -Content {
                                            New-UDStack -Direction row -Spacing 4 -AlignItems 'center' -Content {
                                                
                                                New-UDSelect -Id "RootSelect" -Label "Startpunt (Toplaag)" -DefaultValue $Session:RootOE -OnChange {
                                                    $Session:RootOE = $EventData
                                                    Sync-UDElement -Id "Dyn_Organogram"
                                                } -Option {
                                                    New-UDSelectOption -Name "HOE (Root)" -Value "HOE"
                                                    New-UDSelectOption -Name "BDV (Standaard)" -Value "BDV"
                                                    New-UDSelectOption -Name "1AA (Afdeling)" -Value "1AA"
                                                    New-UDSelectOption -Name "GMT (Gemeente)" -Value "GMT"
                                                    New-UDSelectOption -Name "VER (Vereniging)" -Value "VER"
                                                }

                                                New-UDButton -Id "Btn_ShowEmployees" -Text "Toon Medewerkers" -Icon (New-UDIcon -Icon Users) -Style @{ backgroundColor = '#0078D4'; color = 'white' } -OnClick {
                                                    [string]$Id = (Get-UDElement -Id "SelectedOrgId").Value
                                                    
                                                    if ([string]::IsNullOrWhiteSpace($Id)) { 
                                                        Show-UDToast -Message "Selecteer eerst een afdeling via CTRL + KLIK op een bolletje." -Duration 4000
                                                    } else {
                                                        [string]$EmpQuery = "SELECT personeelsnr AS id, personeelsnr ,Achternaam,Roepnaam,ad_mobile,ad_email,functie_omschrijving,Organisatorische_eenheid_omschrijving,Status_Contract,Last_Einddatum_contracts,Manager FROM [dbo].vwt_hr_contracts WITH (NOLOCK) WHERE ISNULL(Status_Contract, '') NOT LIKE 'AFGESLOTEN%' AND Organisatorische_eenheid_code = '$Id'"
                                                        
                                                        Show-UDModal -MaxWidth 'xl' -Content {
                                                            New-UDElement -Tag 'div' -Attributes @{ className = 'modern-card-container uam-employee-window'; style = @{ padding = '0'; overflow = 'hidden'; border = '1px solid #005fb8'; borderRadius = '8px'; boxShadow = '0 20px 55px rgba(0,0,0,0.32)'; background = 'var(--uam-surface)' } } -Content {
                                                                New-UDElement -Tag 'div' -Attributes @{ className = 'modern-modal-header uam-draggable-modal-header'; title = 'Houd deze blauwe balk vast om het venster te verplaatsen'; style = @{ display = 'flex'; justifyContent = 'space-between'; alignItems = 'center'; boxSizing = 'border-box'; width = '100%'; height = '48px'; minHeight = '48px'; margin = '0'; padding = '0 0 0 16px'; border = '0'; borderBottom = '1px solid #004f9e'; borderRadius = '7px 7px 0 0'; background = '#005fb8'; color = '#ffffff'; boxShadow = 'inset 0 1px 0 rgba(255,255,255,0.16), 0 1px 3px rgba(0,0,0,0.28)'; cursor = 'grab'; userSelect = 'none' } } -Content {
                                                                    New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-title'; style = @{ display = 'flex'; alignItems = 'center'; gap = '10px'; minWidth = '0'; color = '#ffffff'; fontSize = '14px'; fontWeight = '600'; pointerEvents = 'none' } } -Content {
                                                                        New-UDIcon -Icon 'Users'
                                                                        New-UDElement -Tag 'span' -Content { "Medewerkers van: $Id" }
                                                                    }
                                                                    New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-controls'; style = @{ display = 'flex'; alignItems = 'stretch'; alignSelf = 'stretch'; marginLeft = 'auto' } } -Content {
                                                                        New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-drag-hint'; style = @{ display = 'flex'; alignItems = 'center'; gap = '8px'; padding = '0 14px'; color = 'rgba(255,255,255,0.86)'; fontSize = '12px'; fontWeight = '500'; pointerEvents = 'none' } } -Content {
                                                                            New-UDElement -Tag 'span' -Attributes @{ className = 'uam-modal-drag-grip'; 'aria-hidden' = 'true'; style = @{ width = '18px'; height = '14px'; backgroundImage = 'radial-gradient(circle, currentColor 1.4px, transparent 1.6px)'; backgroundSize = '6px 6px'; opacity = '0.9' } } -Content { }
                                                                            New-UDElement -Tag 'span' -Content { 'Vasthouden en slepen' }
                                                                        }
                                                                        New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-close'; title = 'Sluiten'; style = @{ display = 'flex'; alignItems = 'stretch' } } -Content {
                                                                            New-UDButton -Icon (New-UDIcon -Icon 'Times') -Variant 'contained' -Style @{ backgroundColor = 'transparent'; color = '#ffffff'; minWidth = '48px'; width = '48px'; height = '48px'; padding = '0'; borderRadius = '0 7px 0 0'; boxShadow = 'none' } -OnClick { Hide-UDModal }
                                                                        }
                                                                    }
                                                                }
                                                                New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-body'; style = @{ padding = '18px 20px 20px'; background = 'var(--uam-surface)'; color = 'var(--uam-text)' } } -Content {
                                                                    New-UDXTableModular -SqlQuery $EmpQuery -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                                
                                                New-UDElement -Tag 'span' -Id 'SelectedNameContainer' -Attributes @{ className = 'selected-oe-display' } -Content { "Geen selectie" }
                                                
                                                New-UDElement -Tag 'div' -Attributes @{ className = 'uam-hidden-bridge' } -Content { 
                                                    New-UDTextbox -Id "SelectedOrgId" 
                                                    New-UDButton -Id "Btn_HiddenBridge" -OnClick {
                                                        [string]$NewId = (Get-UDElement -Id "SelectedOrgId").Value
                                                        Set-UDElement -Id "SelectedNameContainer" -Content { "Gekozen: $NewId" }

                                                        if (-not [string]::IsNullOrWhiteSpace($NewId)) {
                                                            [string]$EmpQuery = "SELECT personeelsnr AS id, personeelsnr ,Achternaam,Roepnaam,ad_mobile,ad_email,functie_omschrijving,Organisatorische_eenheid_omschrijving,Status_Contract,Last_Einddatum_contracts,Manager FROM [dbo].vwt_hr_contracts WITH (NOLOCK) WHERE ISNULL(Status_Contract, '') NOT LIKE 'AFGESLOTEN%' AND Organisatorische_eenheid_code = '$NewId'"
                                                            Show-UDModal -MaxWidth 'xl' -Content {
                                                                New-UDElement -Tag 'div' -Attributes @{ className = 'modern-card-container uam-employee-window'; style = @{ padding = '0'; overflow = 'hidden'; border = '1px solid #005fb8'; borderRadius = '8px'; boxShadow = '0 20px 55px rgba(0,0,0,0.32)'; background = 'var(--uam-surface)' } } -Content {
                                                                    New-UDElement -Tag 'div' -Attributes @{ className = 'modern-modal-header uam-draggable-modal-header'; title = 'Houd deze blauwe balk vast om het venster te verplaatsen'; style = @{ display = 'flex'; justifyContent = 'space-between'; alignItems = 'center'; boxSizing = 'border-box'; width = '100%'; height = '48px'; minHeight = '48px'; margin = '0'; padding = '0 0 0 16px'; border = '0'; borderBottom = '1px solid #004f9e'; borderRadius = '7px 7px 0 0'; background = '#005fb8'; color = '#ffffff'; boxShadow = 'inset 0 1px 0 rgba(255,255,255,0.16), 0 1px 3px rgba(0,0,0,0.28)'; cursor = 'grab'; userSelect = 'none' } } -Content {
                                                                        New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-title'; style = @{ display = 'flex'; alignItems = 'center'; gap = '10px'; minWidth = '0'; color = '#ffffff'; fontSize = '14px'; fontWeight = '600'; pointerEvents = 'none' } } -Content {
                                                                            New-UDIcon -Icon 'Users'
                                                                            New-UDElement -Tag 'span' -Content { "Medewerkers van: $NewId" }
                                                                        }
                                                                        New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-controls'; style = @{ display = 'flex'; alignItems = 'stretch'; alignSelf = 'stretch'; marginLeft = 'auto' } } -Content {
                                                                            New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-drag-hint'; style = @{ display = 'flex'; alignItems = 'center'; gap = '8px'; padding = '0 14px'; color = 'rgba(255,255,255,0.86)'; fontSize = '12px'; fontWeight = '500'; pointerEvents = 'none' } } -Content {
                                                                                New-UDElement -Tag 'span' -Attributes @{ className = 'uam-modal-drag-grip'; 'aria-hidden' = 'true'; style = @{ width = '18px'; height = '14px'; backgroundImage = 'radial-gradient(circle, currentColor 1.4px, transparent 1.6px)'; backgroundSize = '6px 6px'; opacity = '0.9' } } -Content { }
                                                                                New-UDElement -Tag 'span' -Content { 'Vasthouden en slepen' }
                                                                            }
                                                                            New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-close'; title = 'Sluiten'; style = @{ display = 'flex'; alignItems = 'stretch' } } -Content {
                                                                                New-UDButton -Icon (New-UDIcon -Icon 'Times') -Variant 'contained' -Style @{ backgroundColor = 'transparent'; color = '#ffffff'; minWidth = '48px'; width = '48px'; height = '48px'; padding = '0'; borderRadius = '0 7px 0 0'; boxShadow = 'none' } -OnClick { Hide-UDModal }
                                                                            }
                                                                        }
                                                                    }
                                                                    New-UDElement -Tag 'div' -Attributes @{ className = 'uam-modal-window-body'; style = @{ padding = '18px 20px 20px'; background = 'var(--uam-surface)'; color = 'var(--uam-text)' } } -Content {
                                                                        New-UDXTableModular -SqlQuery $EmpQuery -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                                                                    }
                                                                }
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        }

                                        New-UDDynamic -Id "Dyn_Organogram" -Content {
                                            [string]$CurrentRoot = $Session:RootOE
                                            [string]$CanvasId = "canvas_$([guid]::NewGuid().ToString('N'))"
                                            
                                            [string]$SqlQuery = @"
                                            DECLARE @RootID VARCHAR(100);
                                            SELECT TOP 1 @RootID = id FROM [dbo].[GG_YF_OrganizationUnits] WITH (NOLOCK) WHERE shortName LIKE '%' + '$CurrentRoot' + '%' OR id = '$CurrentRoot';
                                            IF @RootID IS NULL BEGIN SELECT TOP 1 @RootID = id FROM [dbo].[GG_YF_OrganizationUnits] WITH (NOLOCK) WHERE parentOrgUnit IS NULL OR parentOrgUnit = '' OR parentOrgUnit = '0'; END

                                            IF OBJECT_ID('tempdb..#Hierarchy') IS NOT NULL DROP TABLE #Hierarchy;
                                            CREATE TABLE #Hierarchy (id VARCHAR(100) PRIMARY KEY, shortName VARCHAR(100), parentOrgUnit VARCHAR(100), fullName VARCHAR(500), PathID VARCHAR(900), Level INT);
                                            INSERT INTO #Hierarchy SELECT id, shortName, parentOrgUnit, fullName, CAST(id AS VARCHAR(900)), 0 FROM [dbo].[GG_YF_OrganizationUnits] WITH (NOLOCK) WHERE id = @RootID;
                                            
                                            DECLARE @i INT = 0; WHILE @i < 10 BEGIN
                                                INSERT INTO #Hierarchy SELECT ou.id, ou.shortName, ou.parentOrgUnit, ou.fullName, CAST(h.PathID + '|' + ou.id AS VARCHAR(900)), h.Level + 1 FROM [dbo].[GG_YF_OrganizationUnits] ou WITH (NOLOCK) INNER JOIN #Hierarchy h ON ou.parentOrgUnit = h.id WHERE ISNULL(ou.isblocked,0) = 0 AND ou.id NOT IN (SELECT id FROM #Hierarchy);
                                                IF @@ROWCOUNT = 0 BREAK; SET @i = @i + 1;
                                            END;

                                            IF OBJECT_ID('tempdb..#DirectCounts') IS NOT NULL DROP TABLE #DirectCounts;
                                            SELECT organizationUnit AS UnitID, COUNT(id) AS DirectCount INTO #DirectCounts FROM [dbo].[GG_YF_Employments] WITH (NOLOCK) WHERE ISNULL(hireDate, '19000101') <= CAST(GETDATE() AS DATE) AND ISNULL(dischargeDate, '21000101') >= CAST(GETDATE() AS DATE) GROUP BY organizationUnit;
                                            
                                            IF OBJECT_ID('tempdb..#ChildCounts') IS NOT NULL DROP TABLE #ChildCounts;
                                            SELECT parentOrgUnit, COUNT(*) as ChildCount INTO #ChildCounts FROM #Hierarchy GROUP BY parentOrgUnit;

                                            IF OBJECT_ID('tempdb..#FinalRollup') IS NOT NULL DROP TABLE #FinalRollup;
                                            SELECT h1.id, SUM(ISNULL(dc.DirectCount, 0)) AS TotalCount INTO #FinalRollup FROM #Hierarchy h1 INNER JOIN #Hierarchy h2 ON h2.PathID LIKE h1.PathID + '%' LEFT JOIN #DirectCounts dc ON h2.id = dc.UnitID GROUP BY h1.id;
                                            
                                            SELECT h.id AS Id, h.parentOrgUnit AS ParentId, h.shortName AS Label, h.fullName AS Title, h.Level AS NodeLevel, 
                                                   ISNULL(fr.TotalCount,0) AS TotalCount, ISNULL(dc.DirectCount, 0) AS DirectCount, ISNULL(cc.ChildCount, 0) AS ChildCount 
                                            FROM #Hierarchy h 
                                            LEFT JOIN #FinalRollup fr ON h.id = fr.id 
                                            LEFT JOIN #DirectCounts dc ON h.id = dc.UnitID
                                            LEFT JOIN #ChildCounts cc ON h.id = cc.parentOrgUnit;
"@
                                            $SqlResult = Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $SqlQuery
                                            
                                            [array]$NodesArray = @(); [array]$EdgesArray = @()
                                            if ($null -ne $SqlResult) {
                                                foreach ($Row in $SqlResult) {
                                                    [int]$Direct = $Row.DirectCount
                                                    [int]$Total = $Row.TotalCount
                                                    [int]$Children = $Row.ChildCount
                                                    $IsHidden = if ($Row.NodeLevel -le 2) { $false } else { $true }
                                                    
                                                    [string]$Icon = if ($Children -gt 0) { " ▼" } else { "" }
                                                    [int]$BWidth = if ($Children -gt 0) { 3 } else { 1 }
                                                    $HasDashes = if ($Direct -eq 0) { $true } else { $false }
                                                    
                                                    $NodeObj = @{ 
                                                        id = [string]$Row.Id; 
                                                        shortName = [string]$Row.Label;
                                                        fullName = [string]$Row.Title;
                                                        label = "$($Row.Label)$Icon`n($Direct / $Total)"; 
                                                        title = "$($Row.Title)`nDirect: $Direct`nTotaal: $Total`nOnderliggende Afdelingen: $Children`n`nCTRL + Klik = Direct Medewerkers Tonen`nDubbelklik = In/Uitklappen"; 
                                                        group = [int]$Row.NodeLevel; 
                                                        hidden = $IsHidden;
                                                        baseHidden = $IsHidden;
                                                        borderWidth = $BWidth;
                                                        shapeProperties = @{ borderDashes = $HasDashes }
                                                    }

                                                    $NodesArray += $NodeObj

                                                    if (-not [string]::IsNullOrWhiteSpace($Row.ParentId) -and $Row.ParentId -ne '0' -and $Row.NodeLevel -gt 0) { 
                                                        $EdgesArray += @{ from = [string]$Row.ParentId; to = [string]$Row.Id } 
                                                    }
                                                }
                                            }

                                            # Expliciete InputObject voorkomt "null" errors in PS 5.1 bij lege arrays
                                            [string]$NodesJson = ConvertTo-Json -InputObject @($NodesArray) -Depth 5 -Compress -ErrorAction SilentlyContinue
                                            [string]$EdgesJson = ConvertTo-Json -InputObject @($EdgesArray) -Depth 5 -Compress -ErrorAction SilentlyContinue

                                            # Veiligheidsvalnet: Als SQL helemaal leeg terugkomt (bijv. als de afdeling niet meer bestaat),
                                            # zorg er dan voor dat Javascript niet crasht met een 'Unexpected token ;' door lege brackets in te vullen.
                                            if ([string]::IsNullOrWhiteSpace($NodesJson)) { $NodesJson = "[]" }
                                            if ([string]::IsNullOrWhiteSpace($EdgesJson)) { $EdgesJson = "[]" }
                                            # ------------------------------

                                            New-UDHtml -Markup @"
                                            <div style="display: flex; flex-direction: column;">
                                                <div style="position: relative; width: 100%; height: 750px; background: var(--uam-surface-soft); border: 1px solid var(--uam-border); border-radius: 4px;">
                                                    
                                                    <div style="position: absolute; top: 15px; left: 15px; z-index: 100;">
                                                        <input type="text" class="search-box" id="searchNodes_$CanvasId" placeholder="Zoek op omschrijving (bijv. 'ink')..." onkeyup="window.filterUamNodes(this.value)">
                                                    </div>

                                                    <div class="float-btns">
                                                        <button onclick="window.uamNet.moveTo({scale: window.uamNet.getScale() * 1.2})">Inzoomen</button>
                                                        <button onclick="window.uamNet.moveTo({scale: window.uamNet.getScale() * 0.8})">Uitzoomen</button>
                                                        <button onclick="window.uamNet.fit()">Centreren</button>
                                                        <button id="toggleBtn_$CanvasId" onclick="window.toggleUamLayout()">Naar Zwevend</button>
                                                        <button class="btn-accent" onclick="window.toggleUamConfig()">⚙️ Geavanceerd</button>
                                                    </div>
                                                    <div id="$CanvasId" style="width: 100%; height: 100%; display: flex; align-items: center; justify-content: center; font-family: 'Inter', sans-serif; font-weight: 600; color: var(--uam-text-muted);">Laden...</div>
                                                </div>
                                                
                                                <div id="config_$CanvasId" style="display: none; width: 100%; max-height: 400px; overflow-y: auto; background: var(--uam-surface); padding: 20px; border: 1px solid var(--uam-border); border-top: none; border-radius: 0 0 4px 4px;">
                                                    <div class="vis-config-header">⚙️ Vis.js Geavanceerde Physics & Layout Instellingen</div>
                                                    <div id="vis-config-container_$CanvasId" class="vis-configuration-wrapper"></div>
                                                </div>
                                            </div>
"@
                                            [string]$JS_Injection = @"
                                            (function() {
                                                var myCanvasId = '$CanvasId';
                                                var myConfigId = 'vis-config-container_$CanvasId';
                                                
                                                var rawNodes = $NodesJson; 
                                                var rawEdges = $EdgesJson;

                                                function initNativeVis() {
                                                    if (typeof vis === 'undefined') {
                                                        if (!document.getElementById('vis-lib')) {
                                                            var script = document.createElement('script');
                                                            script.id = 'vis-lib';
                                                            script.src = 'https://cdnjs.cloudflare.com/ajax/libs/vis-network/9.1.2/standalone/umd/vis-network.min.js';
                                                            document.head.appendChild(script);
                                                        }
                                                        setTimeout(initNativeVis, 50);
                                                        return;
                                                    }

                                                    var container = document.getElementById(myCanvasId);
                                                    var configContainer = document.getElementById(myConfigId);
                                                    if(!container || !configContainer) { setTimeout(initNativeVis, 50); return; }
                                                    container.innerHTML = ''; 
                                                    
                                                    var nodes = new vis.DataSet(rawNodes); 
                                                    var edges = new vis.DataSet(rawEdges);

                                                    window.uamLayoutMode = 'Hierarchical';
                                                    
                                                    function getOpts(mode) {
                                                        var baseConf = {
                                                            configure: { enabled: true, container: configContainer, showButton: false },
                                                            nodes: { shadow: true, font: { face: 'Inter', size: 14 }, shape: 'dot' },
                                                            groups: { 
                                                                0: { shape: 'diamond', color: { background: '#1e293b', border: '#0f172a' }, font: {color: 'white'} }, 
                                                                1: { shape: 'square', color: { background: '#64748b', border: '#334155' }, font: {color: 'white'} }, 
                                                                2: { shape: 'hexagon', color: { background: '#3b82f6', border: '#1d4ed8' }, font: {color: 'white'} }, 
                                                                3: { shape: 'dot', color: { background: '#f59e0b', border: '#d97706' } }, 
                                                                4: { shape: 'dot', color: { background: '#10b981', border: '#059669' }, font: {color: 'white'} } 
                                                            },
                                                            interaction: { hover: true, dragNodes: true, multiselect: false }
                                                        };

                                                        if(mode === 'Hierarchical') {
                                                            baseConf.layout = { hierarchical: { enabled: true, direction: 'UD', sortMethod: 'directed', levelSeparation: 150, nodeSpacing: 100 } };
                                                            baseConf.physics = { enabled: false };
                                                        } else {
                                                            baseConf.layout = { hierarchical: false };
                                                            baseConf.physics = { enabled: true, solver: 'forceAtlas2Based', forceAtlas2Based: { springLength: 50 } };
                                                        }
                                                        return baseConf;
                                                    }

                                                    function attachNetworkEvents(network) {
                                                        network.on('click', function(p) {
                                                            if (p.nodes.length > 0 && (p.event.srcEvent.ctrlKey || p.event.srcEvent.metaKey)) {
                                                                var node = nodes.get(p.nodes[0]); 
                                                                if(!node) return;
                                                                var code = node.shortName;

                                                                var setReactVal = function(id, val) {
                                                                    var el = document.getElementById(id);
                                                                    var inp = (el && el.tagName !== 'INPUT') ? el.querySelector('input') : el;
                                                                    if(inp) {
                                                                        Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set.call(inp, val);
                                                                        inp.dispatchEvent(new Event('input', { bubbles: true }));
                                                                    }
                                                                };
                                                                setReactVal('SelectedOrgId', code);

                                                                var label = document.getElementById('SelectedNameContainer');
                                                                if(label) label.innerText = 'Gekozen: ' + code;

                                                                var wrap = document.getElementById('Btn_HiddenBridge');
                                                                if(wrap) {
                                                                    var btn = wrap.tagName === 'BUTTON' ? wrap : wrap.querySelector('button');
                                                                    if(btn) btn.dispatchEvent(new MouseEvent('click', { bubbles: true }));
                                                                }
                                                            } else if (p.nodes.length === 0) {
                                                                var label = document.getElementById('SelectedNameContainer');
                                                                if(label) label.innerText = 'Geen selectie';
                                                                
                                                                var el = document.getElementById('SelectedOrgId');
                                                                var inp = (el && el.tagName !== 'INPUT') ? el.querySelector('input') : el;
                                                                if(inp) {
                                                                    Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set.call(inp, '');
                                                                    inp.dispatchEvent(new Event('input', { bubbles: true }));
                                                                }
                                                            }
                                                        });

                                                        network.on('doubleClick', function(p) {
                                                            if (p.nodes.length === 1) {
                                                                var parentId = p.nodes[0];
                                                                var childIds = edges.get().filter(function(e){ return e.from === parentId; }).map(function(e){ return e.to; });
                                                                if (childIds.length > 0) {
                                                                    var firstChildNode = nodes.get(childIds[0]);
                                                                    if (firstChildNode) {
                                                                        var isHiding = !firstChildNode.hidden;
                                                                        nodes.update(childIds.map(function(id){ return {id: id, hidden: isHiding}; }));
                                                                    }
                                                                }
                                                            }
                                                        });
                                                    }

                                                    if(window.uamNet) { window.uamNet.destroy(); }
                                                    window.uamNet = new vis.Network(container, {nodes:nodes, edges:edges}, getOpts(window.uamLayoutMode));
                                                    attachNetworkEvents(window.uamNet);

                                                    window.filterUamNodes = function(searchText) {
                                                        var text = searchText.toLowerCase();

                                                        if(!text) {
                                                            nodes.clear();
                                                            nodes.add(rawNodes);
                                                            if(window.uamNet) window.uamNet.fit({animation: {duration: 500}});
                                                            return;
                                                        }

                                                        var matchingIds = new Set();
                                                        var pathsToKeep = new Set();

                                                        rawNodes.forEach(function(n) {
                                                            if(n.fullName && n.fullName.toLowerCase().indexOf(text) !== -1) {
                                                                matchingIds.add(n.id);
                                                            }
                                                        });

                                                        function traceParents(nodeId) {
                                                            pathsToKeep.add(nodeId);
                                                            var connectedEdges = rawEdges.filter(function(e) { return e.to === nodeId; });
                                                            connectedEdges.forEach(function(e) {
                                                                if(!pathsToKeep.has(e.from)) traceParents(e.from);
                                                            });
                                                        }
                                                        matchingIds.forEach(function(id) { traceParents(id); });

                                                        var updates = [];
                                                        rawNodes.forEach(function(n) {
                                                            if (pathsToKeep.has(n.id)) {
                                                                var updatedNode = Object.assign({}, n);
                                                                updatedNode.hidden = false;
                                                                updatedNode.opacity = matchingIds.has(n.id) ? 1 : 0.2;
                                                                updates.push(updatedNode);
                                                            }
                                                        });
                                                        
                                                        nodes.clear();
                                                        nodes.add(updates);
                                                        
                                                        if(window.uamNet) window.uamNet.fit({animation: {duration: 500}});
                                                    };

                                                    window.toggleUamLayout = function() {
                                                        window.uamLayoutMode = (window.uamLayoutMode === 'Hierarchical') ? 'Scattered' : 'Hierarchical';
                                                        document.getElementById('toggleBtn_' + myCanvasId).innerText = (window.uamLayoutMode === 'Hierarchical') ? 'Naar Zwevend' : 'Naar Horizontaal';
                                                        window.uamNet.destroy();
                                                        window.uamNet = new vis.Network(container, {nodes:nodes, edges:edges}, getOpts(window.uamLayoutMode));
                                                        attachNetworkEvents(window.uamNet);
                                                        window.uamNet.fit({animation: {duration: 500}});
                                                    };

                                                    window.toggleUamConfig = function() {
                                                        var panel = document.getElementById('config_' + myCanvasId);
                                                        if(panel.style.display === 'none') {
                                                            panel.style.display = 'block';
                                                        } else {
                                                            panel.style.display = 'none';
                                                        }
                                                    };
                                                }
                                                
                                                initNativeVis();
                                            })();
"@
                                            Invoke-UDJavaScript -JavaScript $JS_Injection
                                        }
                                    }
                                }
                            }
                        }
                    }

                    # ==========================================
                    # TAB 2: LOGGING DATA (READ ONLY)
                    # ==========================================
                    New-UDTab -Text "Logging Data" -Icon (New-UDIcon -Icon Database) -Dynamic -Content {
                        New-UDElement -Tag 'div' -Attributes @{ className = 'tab-content-wrapper' } -Content {
                            New-UDStack -Direction column -Spacing 6 -Content {

                                $Sql_MinimalLogging = @"
                                    SELECT l.[LogID],[username],[userdomain],[data_collection_type],[data],[first_logged_datetime],COUNT(l.[LogID]) AS [AantalKeerGebruikt],CAST(MIN(l.[first_logged_datetime]) AS DATE) AS [EersteSessieDatum],CAST(MAX(l.[first_logged_datetime]) AS DATE) AS [LaatsteSessieDatum] 
                                    FROM [dbo].[uam_log_minimal] l WITH (NOLOCK) LEFT JOIN [dbo].[uam_log_minimal_dates] d WITH (NOLOCK) 	ON d.LogID = l.LogID
                                    GROUP BY l.[LogID],[username],[userdomain],[data_collection_type],[data],[first_logged_datetime]
"@

                                New-UDElement -Tag 'div' -Content { 
                                    New-UDTypography -Text "Minimal Logging" -Variant "h6" -ClassName "table-section-title"
                                    New-UDXTableModular -UseDictionary $true -Dictionary $Global:DataDictionary -SqlQuery $Sql_MinimalLogging -DefaultSortColumn "LaatsteSessieDatum DESC" -DefaultSortDirection "DESC"  -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false 
                                }
                                
                                New-UDElement -Tag 'div' -Content { 
                                    New-UDTypography -Text "Process Logging" -Variant "h6" -ClassName "table-section-title"
                                    New-UDXTableModular -UseDictionary $true -Dictionary $Global:DataDictionary -TableName "DeviceProcessLogging" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                                }
                                
                                New-UDElement -Tag 'div' -Content { 
                                    New-UDTypography -Text "Browser Logging" -Variant "h6" -ClassName "table-section-title"
                                    New-UDXTableModular -UseDictionary $true -Dictionary $Global:DataDictionary -TableName "DeviceBrowserLogging" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                                }
                                
                                New-UDElement -Tag 'div' -Content { 
                                    New-UDTypography -Text "Recent File & Folder Logging" -Variant "h6" -ClassName "table-section-title"
                                    New-UDXTableModular -UseDictionary $true -Dictionary $Global:DataDictionary -TableName "DeviceRecentFileAndFolderLogging" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                                }
                                
                            }
                        }
                    }

                    # ==========================================
                    # TAB 3: DEVICE TYPES & SCRIPTS
                    # ==========================================
                    New-UDTab -Text "Device Scripts & Schedules" -Icon (New-UDIcon -Icon LaptopCode) -Dynamic -Content {
                        New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px'; background = 'var(--uam-surface)'; color = 'var(--uam-text)'; border = '1px solid var(--uam-border)'; borderRadius='8px'; marginTop='10px' } } -Content {
                            New-UDTabs -Tabs {
                                New-UDTab -Text "💻 Device Types" -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ paddingTop = '15px' } } -Content {
                                        New-UDXTableModular -TableName "DeviceTypes" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary -EnableMultiSelect $true
                                    }
                                }
                                New-UDTab -Text "📜 Scripts" -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ paddingTop = '15px' } } -Content {
                                        New-UDXTableModular -TableName "DeviceScripts" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary -EnableMultiSelect $true
                                    }
                                }
                                New-UDTab -Text "⏰ Planningen (Schedules)" -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ paddingTop = '15px' } } -Content {
                                        New-UDXTableModular -TableName "DeviceScriptSchedules" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary -EnableMultiSelect $true
                                    }
                                }
                                New-UDTab -Text "🛠️ Reference Data" -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ paddingTop = '15px' } } -Content {
                                        New-UDXTableModular -TableName "SystemLookups" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary -EnableMultiSelect $true
                                    }
                                }
                            }
                        }
                    }


                    # ==========================================
                    # TAB 4: SYSTEM SETTINGS (UAM)
                    # ==========================================
                    New-UDTab -Text "UAM Settings" -Icon (New-UDIcon -Icon Cogs) -Dynamic -Content {
                        New-UDElement -Tag 'div' -Attributes @{ className = 'tab-content-wrapper' } -Content { 
                            New-UDTabs -Tabs {
                                New-UDTab -Text "Global Settings" -Icon (New-UDIcon -Icon Globe) -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        New-UDTypography -Text "Global Device Logging Settings" -Variant "h6" -ClassName "table-section-title"
                                        New-UDXTableModular -TableName "DeviceLoggingSettings" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary -ShowDeleteButton $false -DefaultSortColumn 'Setting_Group'
                                    }
                                }
                                New-UDTab -Text "Process Exclusions" -Icon (New-UDIcon -Icon Ban) -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        New-UDStack -Direction column -Spacing 6 -Content {
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Process Exclusions (CRUD Modal)" -Variant "h6" -ClassName "table-section-title"
                                                New-UDXTableModular -TableName "DeviceProcess2Exclude" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary
                                            }
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Process Logging Analytics (Candidates for Exclusion)" -Variant "h6" -ClassName "table-section-title"

                                                # FIX: Interne ORDER BY is toegevoegd op SQL niveau voor stabiliteit
                                                [string]$AnalyticsQuery = @"
SELECT 
    [processname]        = ISNULL(dl.[processname], ''),
    [FullpathExecutable] = ISNULL(dl.[FullpathExecutable], ''),
    [product]            = ISNULL(dl.[product], ''),
    [company]            = ISNULL(dl.[company], ''),
    [reccount]           = COUNT(*),
    [found_in_exclusions] = (
        SELECT COUNT(*) 
        FROM [dbo].[DeviceProcess2Exclude] ex WITH (NOLOCK)
        WHERE ISNULL(ex.enabled, 0) = 1
         AND (isnull(dl.processname,'') LIKE REPLACE(isnull(ex.processnameExpression, ''), '*', '%'))
          AND (isnull(dl.FullpathExecutable,'') LIKE REPLACE(isnull(ex.FullpathExecutableExpression,''), '*', '%'))
          AND (isnull(dl.product,'') LIKE REPLACE(isnull(ex.productExpression,''), '*', '%'))
          AND (isnull(dl.company,'') LIKE REPLACE(isnull(ex.companyExpression, ''), '*', '%'))
    ),
    [min_DateTimeStamp] = MIN(dl.datetimestamp),
    [max_DateTimeStamp] = MAX(dl.datetimestamp)
FROM [dbo].[DeviceProcessLogging_archive] dl WITH (NOLOCK)
GROUP BY 
    [processname],
    [FullpathExecutable],
    [product],
    [company]
"@

                                                $ProcessLoggingAnalytics = @(
                                                    @{
                                                        Name = 'Toevoegen aan Exclusions'
                                                        Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "Is Niet mogelijk" -BackgroundColor "#10b981" -Duration 10000
                                                            } else {
                                                                $SelectedRows | foreach-Object {
                                                                    $InsertQuery = "INSERT INTO [dbo].[DeviceProcess2Exclude] ([Processname],[ProcessnameExpression],[FullpathExecutable],[FullpathExecutableExpression],[Product],[ProductExpression],[Company],[CompanyExpression])"
                                                                    $InsertQuery += "VALUES ('$($_.ProcessName)','$($_.ProcessName)','$($_.FullpathExecutable)','$($_.FullpathExecutable)','$($_.Product)','$($_.Product)','$($_.Company)','$($_.Company)')"
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $InsertQuery -ErrorAction Stop
                                                                    Show-UDToast -Message "Record toegevoegd aan tabel DeviceProcess2Exclude voor procesname = $($_.ProcessName)." -BackgroundColor '#10b981'
                                                                }
                                                            }
                                                        }
                                                    }
                                                    @{
                                                        Name = 'Toevoegen aan Application Match'
                                                        Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "Is Niet mogelijk" -BackgroundColor "#10b981" -Duration 10000
                                                            } else {
                                                                $SelectedRows | foreach-Object {
                                                                    $ProcessName2Insert = if (-not [string]::IsNullOrWhiteSpace($_.FullpathExecutable)){$_.FullpathExecutable}else{$_.ProcessName}
                                                                    $InsertQuery = "INSERT INTO [dbo].[DeviceApplicationMatches] ([DeviceApplicationProcessnameExpression])"
                                                                    $InsertQuery += "VALUES ('$($ProcessName2Insert)')"
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $InsertQuery -ErrorAction Stop
                                                                    Show-UDToast -Message "Record toegevoegd aan tabel DeviceApplicationMatches voor ProcessName = $($_.ProcessName)." -BackgroundColor '#10b981'
                                                                }
                                                            }
                                                        }
                                                    }
                                                )
                                                $RecordOpmaak = { 
                                                    try { 
                                                        if ([datetime]$EventData.max_DateTimeStamp -lt (Get-Date).AddDays(-14)) { 
                                                            return @{ backgroundColor = '#fee2e2' } 
                                                        } 
                                                    } catch {} 
                                                }
                                                New-UDXTableModular -SqlQuery $AnalyticsQuery -DefaultSortColumn "reccount" -DefaultSortDirection "DESC" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false -EnableMultiSelect $true -CustomActions $ProcessLoggingAnalytics -OnRowStyle $RecordOpmaak
                                            }
                                        }
                                    }
                                }

                                New-UDTab -Text "Browser Logging Exclusions" -Icon (New-UDIcon -Icon Ban) -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        New-UDStack -Direction column -Spacing 6 -Content {
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Browser logging Exclusions" -Variant "h6" -ClassName "table-section-title"
                                                New-UDXTableModular -TableName "DeviceBrowserLogging2Exclude" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -UseDictionary $true -Dictionary $Global:DataDictionary
                                            }
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Browser Logging Analytics (Candidates for Exclusion)" -Variant "h6" -ClassName "table-section-title"

                                                # FIX: Interne ORDER BY is toegevoegd op SQL niveau voor stabiliteit
                                                [string]$AnalyticsQuery = @"
SELECT [domain]
     ,reccount = COUNT(*)
     ,[min_DateTimeStamp] = MIN(datetimestamp)
     ,[max_DateTimeStamp] = MAX(datetimestamp)
FROM [dbo].[DeviceBrowserLogging]
GROUP BY [domain]
"@

                                                $ProcessLoggingAnalytics = @(
                                                    @{
                                                        Name = 'Toevoegen aan Exclusions'
                                                        Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "Is Niet mogelijk" -BackgroundColor "#10b981" -Duration 10000
                                                            } else {
                                                                $SelectedRows | foreach-Object {
                                                                    $InsertQuery = "INSERT INTO [dbo].[DeviceBrowserLogging2Exclude] ([Domainexpression],[URLexpression])"
                                                                    $InsertQuery += "VALUES ('$($_.Domain)','$($_.url)')"
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $InsertQuery -ErrorAction Stop
                                                                    Show-UDToast -Message "Record toegevoegd aan tabel DeviceBrowserLogging2Exclude voor Domain = $($_.Domain)." -BackgroundColor '#10b981'
                                                                }
                                                            }
                                                        }
                                                    }

                                                    @{
                                                        Name = 'Toevoegen aan Application Match'
                                                        Icon = (New-UDIcon -Icon 'Play' -Color '#10b981')
                                                        Callback = {
                                                            param([array]$SelectedRows)
                                                            if (@($SelectedRows) -contains 'ALL_RECORDS_FLAG') {
                                                                Show-UDToast -Message "Is Niet mogelijk" -BackgroundColor "#10b981" -Duration 10000
                                                            } else {
                                                                $SelectedRows | foreach-Object {
                                                                    $InsertQuery = "INSERT INTO [dbo].[DeviceApplicationMatches] ([DeviceApplicationDomainExpression])"
                                                                    $InsertQuery += "VALUES ('$($_.Domain)')"
                                                                    Invoke-SqlQuery -SQLInstance $Global:UAMSqlInstance -Database $Global:UAMDatabase -Query $InsertQuery -ErrorAction Stop
                                                                    Show-UDToast -Message "Record toegevoegd aan tabel DeviceApplicationMatches voor Domain = $($_.Domain)." -BackgroundColor '#10b981'
                                                                }
                                                            }
                                                        }
                                                    }

                                                )
                                               $RecordOpmaak = { 
                                                    try { 
                                                        if ([datetime]$EventData.max_DateTimeStamp -lt (Get-Date).AddDays(-14)) { 
                                                            return @{ backgroundColor = '#fee2e2' } 
                                                        } 
                                                    } catch {} 
                                                }
                                                New-UDXTableModular -SqlQuery $AnalyticsQuery -DefaultSortColumn "reccount" -DefaultSortDirection "DESC" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false -EnableMultiSelect $true -CustomActions $ProcessLoggingAnalytics -OnRowStyle $RecordOpmaak
                                            }
                                        }
                                    }
                                }
                                New-UDTab -Text "Application Matches" -Icon (New-UDIcon -Icon Ban) -Dynamic -Content {
                                    New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px 0' } } -Content {
                                        New-UDStack -Direction column -Spacing 6 -Content {
                                            New-UDElement -Tag 'div' -Content {
                                                New-UDTypography -Text "Application Matches" -Variant "h6" -ClassName "table-section-title"

                                                New-UDXTableModular -SqlInstance $Global:UAMSqlInstance -TableName "DeviceApplicationMatches" -DatabaseName $Global:UAMDatabase -SqlQuery $AppMatchQuery -UseDictionary $true -Dictionary $Global:DataDictionary
                                            }
                                        }
                                    }
                                }


                            }
                        }
                    }

                    # ==========================================

                    # ==========================================
                    # TAB: ACCESS REVIEW / AUTORISATIE MATRIX
                    # ==========================================
                    # TAB 5: ERRORS & ANALYTICS
                    # ==========================================
                    New-UDTab -Text "Errors" -Icon (New-UDIcon -Icon ExclamationTriangle) -Dynamic -Content {
                        New-UDElement -Tag 'div' -Attributes @{ className = 'tab-content-wrapper' } -Content {
                            New-UDTypography -Text "Device Logging Errors" -Variant "h6" -ClassName "table-section-title"
                            [string]$ErrorQuery = @"
SELECT TOP 1000 [DatetimeStamp],[Computername],[UserName],[UserDNSDomain],[LogLevel],[ErrorMessage],[Script],[Line],[Position],[CallStack],[uam_commandline],[UAM_CreationDate],[UAM_Version],[UAM_Settings],[WindowsVersion] FROM [dbo].[DeviceLoggingErrors] WITH (NOLOCK) ORDER BY [DatetimeStamp] DESC
"@
                            New-UDXTableModular -SqlQuery $ErrorQuery -DefaultSortColumn "DatetimeStamp" -DefaultSortDirection "DESC" -DatabaseName $Global:UAMDatabase -SqlInstance $Global:UAMSqlInstance -ShowAddButton $false -ShowEditButton $false -ShowDeleteButton $false
                        }
                    }

                    # ==========================================
                    # TAB 6: ACTION LOG (AUDIT)
                    # ==========================================
                    New-UDTab -Text "Audit Log" -Icon (New-UDIcon -Icon ShieldAlt) -Dynamic -Content {
                        New-UDElement -Tag 'div' -Attributes @{ style = @{ padding = '20px'; background = 'var(--uam-surface)'; color = 'var(--uam-text)'; border = '1px solid var(--uam-border)'; borderRadius='8px'; marginTop='10px' } } -Content {
                            New-UDTypography -Text "Systeem Audit Trail (ActionLog)" -Variant h5 -Style @{ marginBottom = '15px' }
                            
                            [array]$LogFilters = @(
                                @{ Name = "1. Toon Alle Acties"; SqlWhere = "" },
                                @{ Name = "2. Actietype: Verwijderen"; SqlWhere = "[ActionType] = 'Verwijderen'" },
                                @{ Name = "3. Actietype: Wijzigen"; SqlWhere = "[ActionType] = 'Wijzigen'" },
                                @{ Name = "4. Actietype: Toevoegen"; SqlWhere = "[ActionType] = 'Toevoegen'" },
                                @{ Name = "5. Mutaties: Laatste maand"; SqlWhere = "[Timestamp] >= DATEADD(month, -1, GETDATE())" },
                                @{ Name = "6. Mutaties: Vandaag"; SqlWhere = "DATEDIFF(day, [Timestamp], GETDATE()) = 0" }
                            )

                            [array]$ExtraKols = @(
                                @{ Property = "LogStatus"; Title = "Log Status"; Position = 1; Render = { if ($EventData.ActionType -eq 'Verwijderen') { New-UDIcon -Icon 'TimesCircle' -Color 'red' } else { New-UDIcon -Icon 'CheckCircle' -Color 'green' } } }
                            )

                            $RecordOpmaak = { if ($EventData.ActionType -eq 'Verwijderen') { @{ backgroundColor = 'var(--uam-danger-soft)' } } }
                            
                            New-UDXTableModular -SqlInstance $Global:UAMSqlInstance -DatabaseName $Global:UAMDatabase -TableName "ActionLog" -DefaultSortColumn "Timestamp" -DefaultSortDirection "DESC"  -UseDictionary $true -ShowAddButton $false -ShowDeleteButton $false -ShowEditButton $false -Dictionary $Global:DataDictionary -EnableMultiSelect $false -PreFilters $LogFilters -OnRowStyle $RecordOpmaak #-CustomColumns $ExtraKols
                        }
                    }

                }
                    }
                }
            }
        }
    }
}











