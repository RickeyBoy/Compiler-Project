package tiger.parse;
import tiger.errormsg.ErrorMsg;
%% 

%cup
%char
%state COMMENT

%{

private void newline() {
  errorMsg.newline(yychar);
}

private void err(int pos, String s) {
	errorMsg.error(pos, s);
}

private void err(String s) {
	err(yychar, s);
}

private java_cup.runtime.Symbol tok(int kind, Object value) {    
	return new java_cup.runtime.Symbol(kind, yychar, yychar+yylength(), value);
}

public Yylex(java.io.InputStream s, ErrorMsg e) {
  this(s);
  errorMsg = e;
}

private ErrorMsg errorMsg;

%}

%eofval{
{ 
	return tok(sym.EOF, null);
}
%eofval}       

LineTerminator = \r|\n|\r\n
WhiteSpace = [ \t\f]


%%

<YYINITIAL> {
	{LineTerminator}	{ newline(); }
	{WhiteSpace}	{ /* do nothing */ }
	
	/* Token : Keywords */
	
	"if"  { return tok(sym.IF, null); }
	"for"  { return tok(sym.FOR, null); }
	// to do ....
	
	/* Token : Identifiers */
	
	/*
		{Identifier} { return tok(sym.ID, yytext()); }
	*/
	
	/* Token : Integer */
	
	// should we check very long integer in there?
	[0-9]+ { return tok(sym.INT, new Integer(yytext())); }
	
	// or not?
	[0-9]+ { return tok(sym.INT, new String(yytext())); }
	
	/* Token : String */
  	// to do...
  	
  	/* Token : SEPARATORS AND OPERATORS */
	
	","	{ return tok(sym.COMMA, null); }
	"."	{ return tok(sym.DOT, null); }
	"+"	{ return tok(sym.PLUS, null); }
	
	"/*" { yybegin(COMMENT); }
	
	[^] { return tok(sym.error, yytext()); }
}

<COMMENT> {
	[^] { /* nothing*/ }
}