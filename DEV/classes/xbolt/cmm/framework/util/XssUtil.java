package xbolt.cmm.framework.util;

import org.apache.commons.lang3.StringEscapeUtils;

import java.util.regex.Pattern;


public class XssUtil {

    //강화된 xss pattern
    private static final Pattern[] patterns = new Pattern[]{

            Pattern.compile("(?i)<\\s*script\\b[^>]*>.*?<\\s*/\\s*script\\s*>", Pattern.DOTALL),
            Pattern.compile("(?i)%3C\\s*script\\b[^>]*%3E.*?%3C\\s*/\\s*script%3E", Pattern.DOTALL),
            Pattern.compile("(?i)<[^>]+\\s+src\\s*=\\s*['\"]\\s*javascript:.*?['\"]", Pattern.DOTALL),
            Pattern.compile("(?i)eval\\((.*?)\\)", Pattern.DOTALL),
            Pattern.compile("(?i)expression\\((.*?)\\)", Pattern.DOTALL),
            Pattern.compile("(?i)data\\s*:[^\\s;]+\\s*;\\s*base64,", Pattern.DOTALL),
            Pattern.compile("(?i)<[^>]+\\s+on\\w+\\s*=\\s*(['\"]).*?\\1", Pattern.DOTALL),
            Pattern.compile("(?i)<\\s*(iframe|object|embed|form|img)[^>]*>", Pattern.DOTALL),
            Pattern.compile("(?i)<\\s*/?\\s*script\\b", Pattern.DOTALL),
            Pattern.compile("(?i)[\"']?\\s*(javascript:|vbscript:|livescript:|mocha:)\\s*", Pattern.DOTALL)
    };

    //기존 xss pattern
    private static Pattern[] orgPatterns = new Pattern[]{

            Pattern.compile("<script>(.*?)</script>", 2),
            Pattern.compile("%3Cscript%3E(.*?)%3C%2Fscript%3E", 2),
            Pattern.compile("src[\r\n]*=[\r\n]*\\'(.*?)\\'", 42),
            Pattern.compile("src[\r\n]*=[\r\n]*\\\"(.*?)\\\"", 42),
            Pattern.compile("%3C%2Fscript%3E", 2),
            Pattern.compile("%3Cscript(.*?)%3E", 42),
            Pattern.compile("</script>", 2),
            Pattern.compile("<script(.*?)>", 42),
            Pattern.compile("eval\\((.*?)\\)", 42),
            Pattern.compile("expression\\((.*?)\\)", 42),
            Pattern.compile("javascript:", 2),
            Pattern.compile("vbscript:", 2),
            Pattern.compile("onload(.*?)=", 42),
            Pattern.compile("'"),
            Pattern.compile("\""),
            //2025-02-10 XSS on 정규식 추가
            Pattern.compile("(<\\s?[^>]+\\s)" +
                    "(on[\\w\\s]+?=\\s*'[^']*'" +
                    "|on[\\w\\s]+?=\\s*\"[^\"]*\"" +
                    "|on[\\w\\s]+?=[^>]*)" +
                    "([^>]*>)")
    };

    //2025-02-10 XSS filter
    public static String xssCustomFilter(String value) {
        if (value != null) {
            for (Pattern scriptPattern : patterns) {
                if (scriptPattern.matcher(value).find()) {
                    System.out.println("XSS 차단: " + scriptPattern.pattern() + " pattern에 걸림 " + "(" + value + ")");
                    value = escapeEncodingFilter(value);
					/* 이벤트 핸들러 문자열에서 아예 제외 원할때 사용
					value = eventHandlerBlackListFilter(value);
					*/

                }
            }
        }
        return value;
    }


    //2025-02-10 XSS html entity filter
    private static String escapeEncodingFilter(String value) {
        return value == null ? value : StringEscapeUtils.escapeHtml4(value);

    }

    //2025-02-10 XSS filter
    public static String xssFilter(String value) {
        if (value != null) {
            for (Pattern scriptPattern : patterns) {
                if (scriptPattern.matcher(value).find()) {
                    System.out.println("XSS 차단: " + scriptPattern.pattern() + " pattern에 걸림 " + "(" + value + ")");
                    value = value.replaceAll("<", "&lt;").replaceAll(">", "&gt;");
                    value = eventHandlerBlackListFilter(value);
                }
            }

        }
        return value;
    }

    public static boolean invalidXssCheck(String value) {
        if (value != null) {
            for (Pattern scriptPattern : patterns) {
                if (scriptPattern.matcher(value).find()) {
                    System.out.println("XSS 차단: " + scriptPattern.pattern() + " pattern에 걸림 " + "(" + value + ")");
                    return true;
                }
            }
        }
        return false;
    }


    //2025-02-10 XSS event handler filter
    private static String eventHandlerBlackListFilter(String value) {
        if (value != null) {
            value = value.replaceAll("onreset", "");
            value = value.replaceAll("alert", "");
            value = value.replaceAll("onmove", "");
            value = value.replaceAll("onstop", "");
            value = value.replaceAll("onrowsinserted", "");
            value = value.replaceAll("innerHTML", "");
            value = value.replaceAll("msgbox", "");
            value = value.replaceAll("onstart", "");
            value = value.replaceAll("onresize", "");
            value = value.replaceAll("onrowexit", "");
            value = value.replaceAll("onselect", "");
            value = value.replaceAll("onmousewheel", "");
            value = value.replaceAll("ondataavailable", "");
            value = value.replaceAll("onafterprint", "");
            value = value.replaceAll("onafterupdate", "");
            value = value.replaceAll("onmousedown", "");
            value = value.replaceAll("onbeforeactivate", "");
            value = value.replaceAll("ondatasetchanged", "");
            value = value.replaceAll("onbeforecopy", "");
            value = value.replaceAll("onbeforedeactivate", "");
            value = value.replaceAll("onbeforeeditfocus", "");
            value = value.replaceAll("onbeforepaste", "");
            value = value.replaceAll("onbeforeprint", "");
            value = value.replaceAll("onbeforeunload", "");
            value = value.replaceAll("onbeforeupdate", "");
            value = value.replaceAll("onpropertychange", "");
            value = value.replaceAll("ondatasetcomplete", "");
            value = value.replaceAll("oncellchange", "");
            value = value.replaceAll("onlayoutcomplete", "");
            value = value.replaceAll("onmousemove", "");
            value = value.replaceAll("oncontextmenu", "");
            value = value.replaceAll("oncontrolselect", "");
            value = value.replaceAll("onreadystatechange", "");
            value = value.replaceAll("onselectionchange", "");
            value = value.replaceAll("onactivate", "");
            value = value.replaceAll("oncopy", "");
            value = value.replaceAll("oncut", "");
            value = value.replaceAll("onclick", "");
            value = value.replaceAll("onchange", "");
            value = value.replaceAll("onbeforecut", "");
            value = value.replaceAll("ondblclick", "");
            value = value.replaceAll("ondeactivate", "");
            value = value.replaceAll("ondrag", "");
            value = value.replaceAll("ondragend", "");
            value = value.replaceAll("ondragenter", "");
            value = value.replaceAll("ondragleave", "");
            value = value.replaceAll("ondragover", "");
            value = value.replaceAll("ondragstart", "");
            value = value.replaceAll("ondrop", "");
            value = value.replaceAll("onerror", "");
            value = value.replaceAll("onerrorupdate", "");
            value = value.replaceAll("onfilterchange", "");
            value = value.replaceAll("onfinish", "");
            value = value.replaceAll("onfocus", "");
            value = value.replaceAll("onresizestart", "");
            value = value.replaceAll("onunload", "");
            value = value.replaceAll("onselectstart", "");
            value = value.replaceAll("onfocusin", "");
            value = value.replaceAll("onfocusout", "");
            value = value.replaceAll("onhelp", "");
            value = value.replaceAll("onkeydown", "");
            value = value.replaceAll("onkeypress", "");
            value = value.replaceAll("onkeyup", "");
            value = value.replaceAll("onrowsdelete", "");
            value = value.replaceAll("onload", "");
            value = value.replaceAll("onlosecapture", "");
            value = value.replaceAll("onbounce", "");
            value = value.replaceAll("onmouseenter", "");
            value = value.replaceAll("onmouseleave", "");
            value = value.replaceAll("onbefore", "");
            value = value.replaceAll("onmouseover", "");
            value = value.replaceAll("onmouseout", "");
            value = value.replaceAll("onmouseup", "");
            value = value.replaceAll("onresizeend", "");
            value = value.replaceAll("onabort", "");
            value = value.replaceAll("onmoveend", "");
            value = value.replaceAll("onmovestart", "");
            value = value.replaceAll("onrowenter", "");
            value = value.replaceAll("onsubmit", "");
            value = value.replaceAll("onblur", "");
        }
        return value;
    }

}
