# Native filters: Get-ChildItem
 
Get-Help Get-ChildItem -Parameter Filter 
 <#
-Filter <String>
        Specifies a filter in the provider's format 
        or language. The value of this parameter 
        qualifies the Path parameter. The syntax of 
        the filter, including the use of wildcards, 
        depends on the provider. Filters are more efficient 
        than other parameters, because the provider applies 
        them when retrieving the objects, rather than 
        having Windows PowerShell filter the objects after 
        they are retrieved.
#> 

 Get-ChildItem -Filter *.ps1 -Recurse 

 # Native filters: Get-WinEvent
 <#
When a cmdlet has a native filter property, it often passes 
it to the underlying API and is often significantly faster 
and creates less IO than filtering on the pipleine. 
#>

Get-WinEvent -FilterHashtable @{
	logname='application'
	providername='.Net Runtime' 
} 

# Other native filters: Get-ADUser
 
 Get-Help Get-ADUser -Parameter Filter 
 
Get-ADUser -Filter {EmailAddress -like "*"} 
Get-ADUser -Filter {mail -like "*"} 
Get-ADUser -Filter {(EmailAddress -like "*") -and (Surname  -eq "smith")}  

$logonDate = New-Object System.DateTime(2016, 3, 1)
Get-ADUser  -Filter { lastLogon -le $logonDate  } 

Get-Help Get-ADUser -Parameter Filter  
<#
 Syntax: 
The following syntax uses Backus-Naur form to show how to use the PowerShell Expression Language for this 
parameter.
    
<filter>  ::= "{" <FilterComponentList> "}"
<FilterComponentList> ::= <FilterComponent> | <FilterComponent> <JoinOperator> <FilterComponent> | <NotOperator>  
<FilterComponent>
<FilterComponent> ::= <attr> <FilterOperator> <value> | "(" <FilterComponent> ")" 
<FilterOperator> ::= "-eq" | "-le" | "-ge" | "-ne" | "-lt" | "-gt"| "-approx" | "-bor" | "-band" | 
"-recursivematch" | "-like" | "-notlike"
<JoinOperator> ::= "-and" | "-or" 
<NotOperator> ::= "-not" 
<attr> ::= <PropertyName> | <LDAPDisplayName of the attribute> 
<value>::= <compare this value with an <attr> by using the specified <FilterOperator>>
    
For a list of supported types for <value>, see about_ActiveDirectory_ObjectModel. 
#>