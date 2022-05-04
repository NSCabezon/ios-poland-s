var appConfig =
{
	"services":
	{
		"login_pre":
		{
			"url": "https://movilidad.santander.pre.corp/SANMOV_IPAD_NSeg_ENS/ws/SANMOV_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.isban.es/webservices/TECHNICAL_FACADES/Security/F_facseg_security/internet/loginServicesNSegSAN/v1"><soapenv:Header /><soapenv:Body><v1:authenticateCredential facade="loginServicesNSegSAN"><CB_AuthenticationData><password>{0}</password><documento><TIPO_DOCUM_PERSONA_CORP>N</TIPO_DOCUM_PERSONA_CORP><CODIGO_DOCUM_PERSONA_CORP>{1}</CODIGO_DOCUM_PERSONA_CORP></documento></CB_AuthenticationData><userAddress>192.168.1.1</userAddress></v1:authenticateCredential></soapenv:Body></soapenv:Envelope>`
		},
		"login_ocu":
		{
			"url": "https://wwwocu.bsan.mobi/SANMOV_IPAD_NSeg_ENS/ws/SANMOV_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.isban.es/webservices/TECHNICAL_FACADES/Security/F_facseg_security/internet/loginServicesNSegSAN/v1"><soapenv:Header /><soapenv:Body><v1:authenticateCredential facade="loginServicesNSegSAN"><CB_AuthenticationData><password>{0}</password><documento><TIPO_DOCUM_PERSONA_CORP>N</TIPO_DOCUM_PERSONA_CORP><CODIGO_DOCUM_PERSONA_CORP>{1}</CODIGO_DOCUM_PERSONA_CORP></documento></CB_AuthenticationData><userAddress>192.168.1.1</userAddress></v1:authenticateCredential></soapenv:Body></soapenv:Envelope>`
		},
		"login_pro":
		{
			"url": "https://www.bsan.mobi/SANMOV_IPAD_NSeg_ENS/ws/SANMOV_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:v1="http://www.isban.es/webservices/TECHNICAL_FACADES/Security/F_facseg_security/internet/loginServicesNSegSAN/v1"><soapenv:Header /><soapenv:Body><v1:authenticateCredential facade="loginServicesNSegSAN"><CB_AuthenticationData><password>{0}</password><documento><TIPO_DOCUM_PERSONA_CORP>N</TIPO_DOCUM_PERSONA_CORP><CODIGO_DOCUM_PERSONA_CORP>{1}</CODIGO_DOCUM_PERSONA_CORP></documento></CB_AuthenticationData><userAddress>192.168.1.1</userAddress></v1:authenticateCredential></soapenv:Body></soapenv:Envelope>`
		},
		"bkswizink_mov_pre":
		{
			"url": "https://movilidad.santander.pre.corp/TARSAN_WIZINK_ENS_SAN/ws/BAMOBI_WS_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vdr="http://www.isban.es/webservices/TARSAN/Tarjetaswizinkla/F_tarsan_tarjetaswizinkla/ACTarsanTarjetasWizinkLa/vDraft"><soapenv:Header><wsse:Security S12:role="wsssecurity" soapenv:actor="http://www.isban.es/soap/actor/wssecurityUserPass" soapenv:mustUnderstand="1" xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:BinarySecurityToken>{0}</wsse:BinarySecurityToken></wsse:Security></soapenv:Header><soapenv:Body><vdr:getTokenLoginLa facade="ACTarsanTarjetasWizinkLa"><datosConexion><idioma><IDIOMA_ISO>es</IDIOMA_ISO><DIALECTO_ISO>ES</DIALECTO_ISO></idioma><cliente><TIPO_DE_PERSONA>{1}</TIPO_DE_PERSONA><CODIGO_DE_PERSONA>{2}</CODIGO_DE_PERSONA></cliente><canal>{3}</canal><contrato><CENTRO><EMPRESA>{4}</EMPRESA><CENTRO>{5}</CENTRO></CENTRO><PRODUCTO>{6}</PRODUCTO><NUMERO_DE_CONTRATO>{7}</NUMERO_DE_CONTRATO></contrato><empresa>{8}</empresa></datosConexion><documentoIdentidad><documento>{9}</documento></documentoIdentidad></vdr:getTokenLoginLa></soapenv:Body></soapenv:Envelope>`
		},
		"bkswizink_mov_ocu":
		{
			"url": "https://wwwocu.bsan.mobi/TARSAN_WIZINK_ENS_SAN/ws/BAMOBI_WS_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vdr="http://www.isban.es/webservices/TARSAN/Tarjetaswizinkla/F_tarsan_tarjetaswizinkla/ACTarsanTarjetasWizinkLa/vDraft"><soapenv:Header><wsse:Security S12:role="wsssecurity" soapenv:actor="http://www.isban.es/soap/actor/wssecurityUserPass" soapenv:mustUnderstand="1" xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:BinarySecurityToken>{0}</wsse:BinarySecurityToken></wsse:Security></soapenv:Header><soapenv:Body><vdr:getTokenLoginLa facade="ACTarsanTarjetasWizinkLa"><datosConexion><idioma><IDIOMA_ISO>es</IDIOMA_ISO><DIALECTO_ISO>ES</DIALECTO_ISO></idioma><cliente><TIPO_DE_PERSONA>{1}</TIPO_DE_PERSONA><CODIGO_DE_PERSONA>{2}</CODIGO_DE_PERSONA></cliente><canal>{3}</canal><contrato><CENTRO><EMPRESA>{4}</EMPRESA><CENTRO>{5}</CENTRO></CENTRO><PRODUCTO>{6}</PRODUCTO><NUMERO_DE_CONTRATO>{7}</NUMERO_DE_CONTRATO></contrato><empresa>{8}</empresa></datosConexion><documentoIdentidad><documento>{9}</documento></documentoIdentidad></vdr:getTokenLoginLa></soapenv:Body></soapenv:Envelope>`
		},
		"bkswizink_mov_pro":
		{
			"url": "https://www.bsan.mobi/TARSAN_WIZINK_ENS_SAN/ws/BAMOBI_WS_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vdr="http://www.isban.es/webservices/TARSAN/Tarjetaswizinkla/F_tarsan_tarjetaswizinkla/ACTarsanTarjetasWizinkLa/vDraft"><soapenv:Header><wsse:Security S12:role="wsssecurity" soapenv:actor="http://www.isban.es/soap/actor/wssecurityUserPass" soapenv:mustUnderstand="1" xmlns:S12="http://www.w3.org/2003/05/soap-envelope" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:BinarySecurityToken>{0}</wsse:BinarySecurityToken></wsse:Security></soapenv:Header><soapenv:Body><vdr:getTokenLoginLa facade="ACTarsanTarjetasWizinkLa"><datosConexion><idioma><IDIOMA_ISO>es</IDIOMA_ISO><DIALECTO_ISO>ES</DIALECTO_ISO></idioma><cliente><TIPO_DE_PERSONA>{1}</TIPO_DE_PERSONA><CODIGO_DE_PERSONA>{2}</CODIGO_DE_PERSONA></cliente><canal>{3}</canal><contrato><CENTRO><EMPRESA>{4}</EMPRESA><CENTRO>{5}</CENTRO></CENTRO><PRODUCTO>{6}</PRODUCTO><NUMERO_DE_CONTRATO>{7}</NUMERO_DE_CONTRATO></contrato><empresa>{8}</empresa></datosConexion><documentoIdentidad><documento>{9}</documento></documentoIdentidad></vdr:getTokenLoginLa></soapenv:Body></soapenv:Envelope>`
		},
		"bkswizink_nhb":
		{
			"url": "https://hobapa.santander.pre.corp/TAREWD_WIZINK_ENS_SAN/ws/BAMOBI_WS_Def_Listener",
			"soap": `<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:vdr="http://www.isban.es/webservices/TARSAN/Tarjetaswizinkla/F_tarsan_tarjetaswizinkla/ACTarsanTarjetasWizinkLa/vDraft"><soapenv:Header><wsse:Security soapenv:actor="http://www.isban.es/soap/actor/wssecurityUserPass" soapenv:mustUnderstand="1" xmlns:wsse="http://docs.oasis-open.org/wss/2004/01/oasis-200401-wss-wssecurity-secext-1.0.xsd"><wsse:BinarySecurityToken>{0}</wsse:BinarySecurityToken></wsse:Security></soapenv:Header><soapenv:Body><vdr:getTokenLoginLa facade="ACTarewdTarjetasWizinkLa"><datosConexion><idioma><IDIOMA_ISO>es</IDIOMA_ISO><DIALECTO_ISO>ES</DIALECTO_ISO></idioma><contrato><CENTRO><EMPRESA>{1}</EMPRESA><CENTRO>{2}</CENTRO></CENTRO><PRODUCTO>{3}</PRODUCTO><NUMERO_DE_CONTRATO>{4}</NUMERO_DE_CONTRATO></contrato><cliente><TIPO_DE_PERSONA>F</TIPO_DE_PERSONA><CODIGO_DE_PERSONA>{5}</CODIGO_DE_PERSONA></cliente><canal>{6}</canal><empresa>{7}</empresa></datosConexion><documentoIdentidad><documento>{9}</documento></documentoIdentidad></vdr:getTokenLoginLa></soapenv:Body></soapenv:Envelope>`
		},
		"wizink_pre":
		{
			"url": "https://wizinkprees.santander.pre.corp/single-sign-on",
			"soap": `<AutOutputData xmlns:Aut="http://Autentication.Output"><errCode>0</errCode><errDescription/><Datos>{0}</Datos><Key>{1}</Key></AutOutputData>`
		},
		"wizink_ocu":
		{
			"url": "https://www.wizink.es/single-sign-on",
			"soap": `<AutOutputData xmlns:Aut="http://Autentication.Output"><errCode>0</errCode><errDescription></errDescription><Datos>{0}</Datos><Key>{1}</Key></AutOutputData>`
		},
		"wizink_pro":
		{
			"url": "https://www.wizink.es/single-sign-on",
			"soap": `<AutOutputData xmlns:Aut="http://Autentication.Output"><errCode>0</errCode><errDescription></errDescription><Datos>{0}</Datos><Key>{1}</Key></AutOutputData>`
		}
	},
	"contenttype":
	{
		"form": "application/x-www-form-urlencoded",
		"xml": "text/xml"
	}
};

if (!String.prototype.format) {
  String.prototype.format = function() {
    var args = arguments;
    return this.replace(/{(\d+)}/g, function(match, number) {
      return typeof args[number] != 'undefined'
        ? args[number]
        : match
      ;
    });
  };
}

function parserXMLElement(data) {
	if (window.DOMParser) {
			parser = new DOMParser();
			xmlDoc = parser.parseFromString(data, "text/xml");
			return xmlDoc;
	} else {
			xmlDoc = new ActiveXObject("Microsoft.XMLDOM");
			xmlDoc.async = false;
			xmlDoc.loadXML(data);
			return xmlDoc;
	}
}

function myLog(text) {
	var debug = 1;
	if (debug == 1) {
		console.log(text);
	}
}

function getData(data, bkey) {
	iv = bkey.substring(24, 32);
	k = bkey.substring(0, 24);

	var base64 =  CryptoJS.enc.Utf8.parse(k);
	key = CryptoJS.enc.Base64.stringify(base64)

	var Dencrypted = CryptoJS.TripleDES.decrypt(data, base64, {
		iv:CryptoJS.enc.Utf8.parse(iv),
		mode: CryptoJS.mode.CBC,
		padding: CryptoJS.pad.Pkcs7}
	);

	return Dencrypted.toString(CryptoJS.enc.Utf8);
}

function getFirm(s, bkey) {
	iv = bkey.substring(24, 32);
	k = bkey.substring(0, 24);

	var base64 =  CryptoJS.enc.Utf8.parse(k)
	key = CryptoJS.enc.Base64.stringify(base64)

	var encrypted = CryptoJS.TripleDES.encrypt(s, base64, {
		iv:CryptoJS.enc.Utf8.parse(iv),
		mode: CryptoJS.mode.CBC,  //ECB
		padding: CryptoJS.pad.Pkcs7}
	);

	return encrypted.toString();
}

function getBkey(t) {
	var s = atob(t);
	var fs = s.split("#");
	if (fs.length > 4) {
		var f = atob(fs[3]);
		var p = parserXMLElement(f);
		var tp = p.documentElement.getElementsByTagName('tipoPersona')[0].innerHTML;
		var cp = p.documentElement.getElementsByTagName('codigoPersona')[0].innerHTML;
		var r = tp + cp + fs[2];
		r += fs[0].substring(0, 32 - r.length);

		return r;
	}

	return null;
}

function toggleLoader(value) {
	var x = document.getElementById("loader_container");
	x.style.display = value;
}

function createLoader() {
	var x = document.getElementById("loader_container")
	x.innerHTML = `
	<div id="loader">
		<div class="organic">
			<div class="dot"></div>
			<div class="dot"></div>
			<div class="dot"></div>
			<div class="dot"></div>
			<div class="dot"></div>
			<svg class="loader-logo" viewBox="0 0 34 34" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink">
				<title>logo</title>
				<defs></defs>
				<g id="logo">
					<path d="M17.4462047,5.27684074 C17.4462047,8.58722565 23.1107952,12.2613214 23.1107952,16.0409857 C23.1107952,16.0409857 23.1107952,16.4046965 22.9541778,16.7969186 C28.2504846,17.8911333 32,20.4717849 32,23.4955164 C32,27.5610636 25.3127439,30.8968774 17.026749,30.9230769 L16.8693562,30.9230769 C8.66167007,30.9230769 2,27.6912905 2,23.6511723 C2,20.6282114 6.06430104,18.1777868 10.9690642,16.8747465 C10.9690642,18.5430387 16.5553459,23.8337982 16.6863774,25.9698287 C16.6863774,25.9698287 16.7127387,26.1532253 16.7127387,26.3620508 C16.7127387,26.4668488 16.7127387,26.5708763 16.6863774,26.6749037 C17.8912465,26.0491978 17.8912465,24.0942522 17.8912465,24.0942522 C17.8912465,19.4546275 12.4631329,17.396425 12.4631329,12.8353988 C12.4631329,11.0630792 13.3020443,9.75926835 14.0641977,9.39478696 L14.0641977,10.6708571 C14.0641977,13.9820126 19.937353,17.6830784 19.937353,20.7052687 L19.937353,21.6969972 C21.3011656,21.1753187 21.3011656,18.6994652 21.3011656,18.6994652 C21.3011656,14.52912 15.8466906,12.2096929 15.8466906,7.43984131 C15.8466906,5.66752164 16.6863774,4.36371082 17.4462047,4 L17.4462047,5.27684074 Z">
					</path>
				</g>
			</svg>
		</div>
		<svg xmlns="http://www.w3.org/2000/svg" version="1.1">
			<defs>
				<filter id="organic">
					<feGaussianBlur in="SourceGraphic" stdDeviation="4" result="blur"></feGaussianBlur>
					<feColorMatrix in="blur" mode="matrix" values="1 0 0 0 0  0 1 0 0 0  0 0 1 0 0  0 0 0 18 -7" result="organic"></feColorMatrix>
					<feBlend in="SourceGraphic" in2="organic"></feBlend>
				</filter>
			</defs>
		</svg>
		<div class="info">
			<div class="title">Cargando datos</div>
			<div class="subtitle">Un momento, por favor</div>
			<!--<div id="subtitle2">{{subtitle2}}</div>-->
		</div>
	</div>
	`;
}
