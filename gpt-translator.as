string GetTitle()
{
    return "{$CP949=OpenAI 번역$}{$CP950=OpenAI翻译$}{$CP0=OpenAI translate$}";
}

string GetVersion()
{
    return "1.0";
}

string GetDesc()
{
    return "<a href=\"https://openai.com\">https://openai.com</a>";
}

string GetLoginTitle()
{
    return "OpenAI翻译";
}

string GetLoginDesc()
{
    return "使用OpenAI API进行字幕翻译";
}

string GetUserText()
{
    return "";
}

string GetPasswordText()
{
    return "";
}

// API Key 和代理URL
string api_key = "sk-NK7v9mi98wA04Mez0100B69b2c7642249455E71844Af1dA9";
string api_url = "https://api.xty.app/v1/chat/completions";

array<string> LangTable = 
{
    "af", "sq", "am", "ar", "hy", "az", "eu", "be", "bn", "bs", "bg", "ca",
    "zh", "zh-CN", "zh-TW", "hr", "cs", "da", "nl", "en", "et", "fi", "fr",
    "de", "el", "gu", "ht", "he", "hi", "hu", "is", "id", "it", "ja", "kn",
    "ko", "lv", "lt", "mk", "ms", "ml", "mt", "mr", "ne", "no", "fa", "pl",
    "pt", "pa", "ro", "ru", "sr", "si", "sk", "sl", "es", "sw", "sv", "ta",
    "te", "th", "tr", "uk", "ur", "vi", "cy"
};

array<string> GetSrcLangs()
{
    return LangTable;
}

array<string> GetDstLangs()
{
    return LangTable;
}

string Translate(string Text, string &in SrcLang, string &in DstLang)
{
    string UNICODE_RLE = "\u202B";

    if (SrcLang.length() <= 0) SrcLang = "en";
    
    string SendHeader = "Authorization: Bearer " + api_key + "\r\n";
    SendHeader += "Content-Type: application/json\r\n";

    string Post = "{\"model\":\"gpt-3.5-turbo\",\"messages\":[{\"role\":\"system\",\"content\":\"You are a translator.\"},{\"role\":\"user\",\"content\":\"Translate the following text from " + SrcLang + " to " + DstLang + ": " + Text + "\"}]}";

    string ret = "";
    uintptr http = HostOpenHTTP(api_url, "Mozilla/5.0", SendHeader, Post);
    if (http != 0)
    {
        string json = HostGetContentHTTP(http);
        JsonReader Reader;
        JsonValue Root;

        if (Reader.parse(json, Root))
        {
            JsonValue choices = Root["choices"];
            if (choices.isArray())
            {
                JsonValue text = choices[0]["message"]["content"];
                if (text.isString()) ret = text.asString();
            }
        }

        HostCloseHTTP(http);
    }

    if (DstLang == "fa" || DstLang == "ar" || DstLang == "he") ret = UNICODE_RLE + ret;
    SrcLang = "UTF8";
    DstLang = "UTF8";

    return ret;
}
