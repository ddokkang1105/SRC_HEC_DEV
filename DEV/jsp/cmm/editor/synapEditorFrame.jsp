<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" />
<title>Synap Editor Frame</title>
<link rel="stylesheet" type="text/css" href="cmm/js/SynapEditor/synapeditor.min.css" />
<script type="text/javascript" src="cmm/js/SynapEditor/synapeditor.config.js"></script>
<script type="text/javascript" src="cmm/js/SynapEditor/synapeditor.min.js"></script>
<script type="text/javascript" src="cmm/js/SynapEditor/externals/SEDocModelParser/SEDocModelParser.min.js"></script>
<script type="text/javascript" src="cmm/js/SynapEditor/externals/SEShapeManager/SEShapeManager.min.js"></script>
<style>
html, body {
	margin: 0;
	padding: 0;
	background: #fff;
	width: 100%;
	height: 100%;
	overflow-x: hidden;
}

#editorWrap {
	width: 100%;
	height: 100%;
	background: #fff;
	overflow-x: hidden;
}

#synapEditor {
	width: 100%;
	height: 100%;
	overflow-x: hidden;
}
</style>

<script type="text/javascript">
var synapPreviewPluginName = 'customPreviewModal';
var synapEditorInstance = null;
var synapEditorInitialized = false;
var synapEditorBridgeOptions = null;
var synapFullscreenObserver = null;
var synapFullscreenPollTimer = null;

if (window.SynapEditor && typeof window.SynapEditor.addPlugin === 'function' && !window.__synapCustomPreviewPluginRegistered) {
	window.__synapCustomPreviewPluginRegistered = true;
	window.SynapEditor.addPlugin(synapPreviewPluginName, function(editor) {
		return {
			buttonDef: {
				label: 'Preview',
				onClickFunc: function() {
					var previewHtml = '';
					if (editor && typeof editor.getPublishingHtml === 'function') {
						previewHtml = editor.getPublishingHtml() || '';
					}
					try {
						if (window.parent && typeof window.parent.openSynapPreviewModal === 'function') {
							window.parent.openSynapPreviewModal(previewHtml);
						}
					} catch (e) {
						console.error('Synap preview modal open failed', e);
					}
				}
			}
		};
	});
}

function appendCss(doc, href) {
	if (!doc || !href) {
		return;
	}
	if (doc.querySelector('link[href="' + href + '"]')) {
		return;
	}

	var link = doc.createElement('link');
	link.rel = 'stylesheet';
	link.type = 'text/css';
	link.href = href;
	doc.head.appendChild(link);
}

function appendSynapCssToTop() {
	var topDoc = window.top && window.top.document ? window.top.document : document;
	appendCss(topDoc, 'cmm/js/SynapEditor/synapeditor.min.css');
}

function ensureTopSynapContainer() {
	var topDoc = window.top && window.top.document ? window.top.document : document;
	var ui = topDoc.getElementById('synapeditorUI');

	if (!ui) {
		ui = topDoc.createElement('div');
		ui.id = 'synapeditorUI';
		ui.style.position = 'relative';
		ui.style.zIndex = '99999';
		topDoc.body.appendChild(ui);
	}

	return ui;
}

function decodeHtml(html) {
	if (html == null) {
		return '';
	}
	var txt = document.createElement('textarea');
	txt.innerHTML = html;
	return txt.value;
}

function getSynapConfig(editorHeight) {
	return {
		'editor.license': 'cmm/js/SynapEditor/license.json',
		'editor.type': 'document',
		'editor.size.width': 'calc(100% - 2px)',
		'editor.size.height': editorHeight -2 + 'px',
		'editor.lang.default': 'ko',
		'editor.menu.show': true,
		'editor.external.container.selector': '#synapeditorUI',
		'editor.import.api': 'importDoc.do',
		'editor.import.fileFieldName': 'file',
		'editor.import.selectArea.word': true,
		'editor.mode.iframe': {
			'enable': true,
			'style.urls': [
				'cmm/js/SynapEditor/iframeMode/contentsEditStyle.css'
			],
			'script.urls': [
				'cmm/js/SynapEditor/iframeMode/SEPolyfill.min.js'
			]
		},
		'editor.menu.list': [
			'file',
			'edit',
			'view',
			'insert',
			'format',
			'paragraph',
			'table',
			'tools',
			'help'
		],
		'editor.menu.definition': {
			'file': ['new', 'open', '-', 'template', 'print'],
			'edit': ['undo', 'redo', '-', 'copy', 'cut', 'paste'],
			'view': ['fullScreen', '-', 'source', synapPreviewPluginName],
			'insert': ['link', 'unlink', 'bookmark', '-', 'image', 'background', 'video', 'file', '-', 'table', 'div', 'horizontalLine', 'quote', '-', 'specialCharacter', 'emoji'],
			'format': ['bold', 'italic', 'underline', 'strike', '-', 'fontColor', 'fontBackgroundColor'],
			'paragraph': ['paragraphStyleWithText', 'fontFamilyWithText', 'fontSizeWithText', '-', 'align', 'lineHeight', '-', 'bulletList', 'numberedList', 'multiLevelList', '-', 'decreaseIndent', 'increaseIndent'],
			'table': ['table'],
			'tools': ['find'],
			'help': ['help', 'about']
		},
		'editor.toolbar': [
	        'new', 'open', 'template', 'layout', '|',
	        'undo', 'redo', '|',
	        'copy', 'cut', 'paste', '|',
	        'link', 'unlink', 'bookmark', '|',
	        'image', 'background', 'video', 'file', '|',
	        'table', 'div', 'horizontalLine', 'quote', '|',
	        'specialCharacter', 'emoji', '-',
	        'paragraphStyleWithText', '|',
	        'fontFamilyWithText', '|',
	        'fontSizeWithText', '|',
	        'bold', 'italic', 'underline', 'strike', '|',
	        'growFont', 'shrinkFont', '|',
	        'fontColor', 'fontBackgroundColor', '|',
	        'bulletList', 'numberedList', 'multiLevelList', '|',
	        'align', '|',
	        'lineHeight', '|',
	        'decreaseIndent', 'increaseIndent'
	    ],
	};
}

function getEditorRoot() {
	return document.querySelector('.se') || document.querySelector('[class*="se-"][class*="editor"]');
}

function isSynapFullscreenActive(root) {
	var editorRoot = root || getEditorRoot();
	if (!editorRoot) {
		return false;
	}

	var className = editorRoot.className || '';
	if (typeof className === 'string' && /full[\s-_]?screen/i.test(className)) {
		return true;
	}

	if (document.fullscreenElement && document.fullscreenElement.contains(editorRoot)) {
		return true;
	}

	var style = window.getComputedStyle(editorRoot);
	var rect = editorRoot.getBoundingClientRect();
	var fitsViewport = rect.width >= window.innerWidth - 4 && rect.height >= window.innerHeight - 4;
	return style.position === 'fixed' && fitsViewport;
}

function notifyParentFullscreen(isFullscreen) {
	if (!synapEditorBridgeOptions || !synapEditorBridgeOptions.frameId) {
		return;
	}

	try {
		if (window.parent && typeof window.parent.setSynapFrameFullscreen === 'function') {
			window.parent.setSynapFrameFullscreen(synapEditorBridgeOptions.frameId, isFullscreen);
		}
	} catch (e) {
		console.error('SynapEditor fullscreen bridge failed', e);
	}
}

function syncParentFullscreenState() {
	notifyParentFullscreen(isSynapFullscreenActive());
}

function bindSynapFullscreenBridge() {
	if (synapFullscreenObserver) {
		synapFullscreenObserver.disconnect();
		synapFullscreenObserver = null;
	}

	if (synapFullscreenPollTimer) {
		clearInterval(synapFullscreenPollTimer);
		synapFullscreenPollTimer = null;
	}

	var root = getEditorRoot();
	if (!root) {
		synapFullscreenPollTimer = setInterval(function() {
			var delayedRoot = getEditorRoot();
			if (!delayedRoot) {
				return;
			}
			clearInterval(synapFullscreenPollTimer);
			synapFullscreenPollTimer = null;
			bindSynapFullscreenBridge();
		}, 300);
		return;
	}

	synapFullscreenObserver = new MutationObserver(function() {
		syncParentFullscreenState();
	});

	synapFullscreenObserver.observe(root, {
		attributes: true,
		attributeFilter: ['class', 'style']
	});

	document.addEventListener('fullscreenchange', syncParentFullscreenState);
	window.addEventListener('resize', syncParentFullscreenState);
	window.addEventListener('beforeunload', function() {
		notifyParentFullscreen(false);
	});

	syncParentFullscreenState();
}

window.initSynapEditorBridge = function(options) {
	if (synapEditorInitialized) {
		return;
	}

	var config = options || {};
	synapEditorBridgeOptions = config;
	var editorElement = document.getElementById('synapEditor');
	var editorHeight = Number(config.height || 360);
	var initialHtml = decodeHtml(config.html || '');

	appendSynapCssToTop();
	ensureTopSynapContainer();

	editorElement.innerHTML = initialHtml;

	try {
		synapEditorInstance = new SynapEditor(
			'synapEditor',
			getSynapConfig(editorHeight),
			initialHtml
		);
		synapEditorInitialized = true;
		setTimeout(bindSynapFullscreenBridge, 0);
	} catch (e) {
		console.error('SynapEditor frame init failed', e);
	}
};

window.getEditorHtml = function() {
	if (!synapEditorInstance || typeof synapEditorInstance.getPublishingHtml !== 'function') {
		var editorElement = document.getElementById('synapEditor');
		return editorElement ? editorElement.innerHTML : '';
	}
	return synapEditorInstance.getPublishingHtml();
};

window.setEditorHtml = function(html) {
	var value = decodeHtml(html || '');
	var editorElement = document.getElementById('synapEditor');
	if (editorElement) {
		editorElement.innerHTML = value;
	}

	if (!synapEditorInstance) {
		return;
	}

	try {
		if (typeof synapEditorInstance.setPublishingHtml === 'function') {
			synapEditorInstance.setPublishingHtml(value);
			return;
		}
		if (typeof synapEditorInstance.setHTML === 'function') {
			synapEditorInstance.setHTML(value);
			return;
		}
		if (typeof synapEditorInstance.setContent === 'function') {
			synapEditorInstance.setContent(value);
		}
	} catch (e) {
		console.error('SynapEditor set html failed', e);
	}
};
</script>
</head>
<body>
	<div id="editorWrap">
		<div id="synapEditor"></div>
	</div>
</body>
</html>
