#!/bin/awk -f

BEGIN {
	FS=",";
	formato="[from],\t[to],\t+[cost],\t[pathcost]";
	BIG=1000000000;
}

function fatal(str){ print("fatal error: " str); exit(1); }

function max(a,b){ return (a>=b)? a : b ; }

function connesso(i,j){ return ( (i,j) in lato ); }

function costo(i,j){
	return (connesso(i,j))? lato[i,j] : BIG; 
}

function find_argmin(L,size,			j,min,argmin){
	argmin="";
	for (j in nodo){
		if (	L[j,"flag"]!=1 && (argmin=="" || L[j,"value"]<min) ){
			min=L[j,"value"];
			argmin=j;
		}
	}
	if (argmin==""){ fatal("errore: argmin nullo!"); }
	return argmin;
}

function update_pred(L,argmin,j,		 tmp_l){
	if (argmin==j || L[j,"flag"]!=0 || !connesso(argmin,j)){ return; }	
	tmp_l = L[argmin,"value"] + costo(argmin,j);
	if (tmp_l < L[j,"value"]){
		L[j,"value"]=tmp_l;
		L[j,"pred"]=argmin;
	}  
}

function get_string_path(L,dest,		 i,str,fullstr){
	fullstr="";
	for (i=dest; L[i,"pred"]!=-1; i=L[i,"pred"]){
		str=formato;
		sub("\\[from\\]", L[i, "pred"], str);
		sub("\\[to\\]", i, str);
		sub("\\[cost\\]", costo(L[i, "pred"], i), str);
		sub("\\[pathcost\\]", L[i, "value"], str);
		fullstr = (fullstr=="")? (str) : (str ORS fullstr);
	}
	return fullstr;
}

/^[[:alnum:]]+,[[:alnum:]]+,[[:digit:]]+(\.[[:digit:]]+)?$/{
	lato[$1,$2]=$3
	nodo[$1]=nodo[$2]="true";
	size=0; for (i in nodo){ size++; }
}

/^format,.*$/ { formato=substr($0, 1+length("format,") ); }

/^echo,.*$/ 	{ print(substr($0, 1+length("echo,"))); }

/^solve,[[:alnum:]]+,[[:alnum:]]+$/ {

	s=$2;
	for (i in nodo){
		L[i,"value"] = costo(s,i) ;
		L[i,"pred"]  = s ;
		L[i,"flag"]  = 0 ;
	}
	L[s,"value"] =	0 ;
	L[s,"flag"]  =	1 ;
	L[s,"pred"]  = -1 ;

	for (k=1; k<size; k++){
		argmin = find_argmin(L, size);
		L[argmin,"flag"] = 1;
		for (j in nodo){
			 update_pred(L,argmin,j);
		}
	}

	print(get_string_path(L,$3));
}

/^exit$/ { exit(0); }