var rathon = {
		doStart: function(_tab) {
			var operator = new rathon.ConfigOperator();
			operator.get(_tab);
		},
		doConfig: function(_tab) {
			var operator = new rathon.ConfigOperator();
			operator.set(_tab);
		}
};

rathon.ConfigOperator = function() {
	this.uri = '../../console2018/';
	this.getUri = function(_tab) {
		var uri = this.uri;
		
		switch (_tab) {
			case 1:
				uri += '2';
				break;
			case 2: 
				uri += '3';
				break;
			default:
				uri += '1';
		}
		
		return uri;
	};
	
	this.get = function(_tab) {
		var uri = this.getUri(_tab);
		
		var wait = new rathon.util.WaitBar();
		
		var callback = {
				success: function(_o) {
					var json = YAHOO.lang.JSON.parse(_o.responseText);
					
					for (var elemId in json) {
						var elem = document.getElementById(elemId);
						
						if (elem == null) {
							continue;
						}
						
						switch (elemId) {
							case 'SPM_USE_IDP_AUTHENTICATION':
								elem.checked = json[elemId];
								break;
							case 'SPO_USE_OF_AJAX':	
								elem.checked = json[elemId];
								rathon.util.enabledElements(['SPO_AJAX_REQ_METHOD','SPO_AJAX_REQ_NAME','SPO_AJAX_REQ_VALUE'], elem.checked);
								break;
							case 'IDPM_SESSION_PERSISTENCE_METHOD':
								elem.value = json[elemId];
								rathon.util.enabledElements(['IDPM_SESSION_PERSISTENCE_URI'], elem.value.toLowerCase() == 'thread' ? false : true);
								break;
							default:
								elem.value = json[elemId];
						}
					}

					wait.hide();
				},
				failure: function(_o) {
					wait.hide();
					alert(_o.responseText);
				}
		};
		
		wait.show();
		YAHOO.util.Connect.asyncRequest('GET', uri, callback);
	};
	
	var makeTextElementParams = function(_elemId) {
		var elem = document.getElementById(_elemId);
		return _elemId + '=' + elem.value;
	};
	
	var makeCheckboxElementParams = function(_elemId) {
		var val;
		var elem = document.getElementById(_elemId);
		
		if (elem.checked) {
			val = 'true';
		} else {
			val = 'false';
		}
		
		return _elemId + '=' + val;
	};
	
	this.set = function(_tab) {
		var uri = this.getUri(_tab);
		var params = '';
		var elem = '';
		
		switch (_tab) {
			case 1:
				params = makeTextElementParams('SPN_CERT_PATH');
				params += '&' + makeTextElementParams('SPO_LOGIN_PAGE_URI');
				params += '&' + makeTextElementParams('SPO_CUSTOM_SESSION_CREATOR');
				params += '&' + makeTextElementParams('SPO_CUSTOM_SESSION_REDIRECTOR');
				params += '&' + makeTextElementParams('SPO_CHARACTER_ENCODING');
				params += '&' + makeTextElementParams('SPO_SSO_AUTHENTICATION_METHOD');
				params += '&' + makeTextElementParams('SPO_LOGOUT_METHOD');
				params += '&' + makeTextElementParams('SPO_SESSIONKEY_PREFIX');
				params += '&' + makeTextElementParams('SPN_CLIENT_IP_HEADER');				
				break;
			case 2:
				params = makeTextElementParams('IDPO_LOADBALANCE_IP_CONTEXT');
				params += '&' + makeTextElementParams('IDPO_LOADBALANCE_TIME');
				params += '&' + makeTextElementParams('IDPM_SESSION_PERSISTENCE_METHOD');
				params += '&' + makeTextElementParams('IDPM_SESSION_PERSISTENCE_URI');
				params += '&' + makeTextElementParams('IDPM_SESSION_PERSISTENCE_TIME');
				params += '&' + makeTextElementParams('IDPO_SESSION_COOKIE_NM');
				break;
			default:
				params = makeCheckboxElementParams('SPM_USE_IDP_AUTHENTICATION');
				//params += makeTextElementParams('SPO_AUTHENTICATION_URI');
				params += '&' + makeTextElementParams('IDPM_DOMAIN_CONTEXT');
				params += '&' + makeTextElementParams('SPM_SAML_RES_URI');
				//params += '&' + makeTextElementParams('SPM_LOGOUT_REQ_URI');
				params += '&' + makeTextElementParams('SPM_LOGOUT_RES_URI');
				params += '&' + makeTextElementParams('IDPM_SAML_REQ_URI');
				params += '&' + makeTextElementParams('IDPM_LOGIN_REQ_URI');
				params += '&' + makeTextElementParams('IDPM_LOGOUT_REQ_URI');
				params += '&' + makeCheckboxElementParams('SPO_USE_OF_AJAX');
				params += '&' + makeTextElementParams('SPO_AJAX_REQ_METHOD');
				params += '&' + makeTextElementParams('SPO_AJAX_REQ_NAME');
				params += '&' + makeTextElementParams('SPO_AJAX_REQ_VALUE');
		}
		
		var wait = new rathon.util.WaitBar();

		var callback = {
				success: function(_o) {
					wait.hide();
					alert('저장되었습니다.');
				},
				failure: function(_o) {
					wait.hide();
					alert('error');
				}
		};
		
		wait.show(); //alert(params);
		YAHOO.util.Connect.asyncRequest('POST', uri, callback, params);
	};
};

rathon.util = {
		enabledElements : function(_elems, _enabled) {
			for (var i = 0;  i < _elems.length; i++) {
				YAHOO.util.Dom.get(_elems[i]).disabled = !_enabled;
			}
		}
};

rathon.util.WaitBar = function() {
	var self = this;
	
	/* constructor */
	(function() {
		self.panel = new YAHOO.widget.Panel("wait", {
			width : "240px",
			fixedcenter : true,
			close : false,
			draggable : false,
			zindex : 4,
			modal : true,
			visible : false
		});

		self.panel.setHeader("Loading, please wait...");
		self.panel.setBody("<img src=\"http://l.yimg.com/a/i/us/per/gr/gp/rel_interstitial_loading.gif\"/>");
		self.panel.render(document.body);
	})();

	this.show = function() {
		this.panel.show();
	};
	
	this.hide = function() {
		this.panel.hide();
	};
};