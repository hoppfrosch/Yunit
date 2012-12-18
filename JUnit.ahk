;############################
; description: Generate JUnit-XML output for Yunit-Framework (https://github.com/Uberi/Yunit)
;
; author: hoppfrosch
; date: 20121207
;############################
class xml{
; Credits:By Maestrith (http://www.autohotkey.com/board/topic/85010-xml-parser/?hl=msxml)
	__New(param*){
		ref:=param.1,root:=param.2,file:=param.3
		file:=file?file:ref ".xml",root:=!root?ref:root
		temp:=ComObjCreate("MSXML2.DOMDocument"),temp.setProperty("SelectionLanguage","XPath")
		ifexist %file%
		temp.load(file),this.xml:=temp
		else
		this.xml:=xml.CreateElement(temp,root)
		this.file:=file
		xml.list({ref:ref,xml:this.xml,obj:this})
	}
	__Get(){
		return this.xml.xml
	}
	CreateElement(doc,root){
		x:=doc.CreateElement(root),doc.AppendChild(x)
		return doc
	}
	add(path,att="",text="",dup="",find=""){
		main:=this.xml.SelectSingleNode("*")
		for a,b in find
		if found:=main.SelectSingleNode("//" path "[@" a "='" b "']"){
			for a,b in att
			found.setattribute(a,b)
			return found
		}
		if p:=this.xml.SelectSingleNode(path)
		for a,b in att
		p.SetAttribute(a,b)
		else
		{
			p:=main
			Loop,Parse,path,/
			{
				total.=A_LoopField "/"
				if dup
				new:=this.xml.CreateElement(A_LoopField),p.AppendChild(new)
				else if !new:=p.SelectSingleNode("//" Trim(total,"/"))
				new:=this.xml.CreateElement(A_LoopField),p.AppendChild(new)
				p:=new
			}
			for a,b in att
			p.SetAttribute(a,b)
			if Text
			p.text:=text
		}
	}
	remove(){
		this.xml:=""
	}
	save(){
		this.xml.save(this.file)
	}
	transform(){
		this.xml.transformNodeToObject(xml.style(),this.xml)
	}
	ssn(node){
		return this.xml.SelectSingleNode(node)
	}
	sn(node){
		return this.xml.SelectNodes(node)
	}
	style(){
		static
		if !IsObject(xsl){
			xsl:=ComObjCreate("MSXML2.DOMDocument")
			style=
			(
			<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
			<xsl:output method="xml" indent="yes" encoding="UTF-8"/>
			<xsl:template match="@*|node()">
			<xsl:copy>
			<xsl:apply-templates select="@*|node()"/>
			<xsl:for-each select="@*">
			<xsl:text></xsl:text>
			</xsl:for-each>
			</xsl:copy>
			</xsl:template>
			</xsl:stylesheet>
			)
			xsl.loadXML(style), style:=null
		}
		return xsl
	}
}
m(x*){
	for a,b in x
	list.=b "`n"
	MsgBox,% list
}



class YunitJUnit{
; implemented according http://stackoverflow.com/questions/4922867/junit-xml-format-specification-that-hudson-supports
    __new(instance)
    {
		this.filename := "junit.xml"
		; As XML class appends to file, if it already exists, the file has to be deleted if it exists already
		if FileExist(this.filename) {
			FileDelete % this.filename
		}
		this.xml := new xml("junit","testsuite",this.filename)

		Return this
    }
	
	__Delete() {
		this.xml.transform()			;Transforms them from a file without indentations to a file with them.
		; m(this.xml[])					;Displays the xml files.
		this.xml.save()
	}

    
    Update(Category, TestName, Result)
    {
		this.xml.add("testcase",{classname:Category, name:Testname},"",1)
		If IsObject(Result) {
			msg := "Line #" result.line ": " result.message
			this.xml.add("testcase/failure",{message:msg},"",1)
		}
	}
    

}
