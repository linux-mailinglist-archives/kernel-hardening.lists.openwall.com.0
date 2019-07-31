Return-Path: <kernel-hardening-return-16675-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id A59E87CB6C
	for <lists+kernel-hardening@lfdr.de>; Wed, 31 Jul 2019 20:02:17 +0200 (CEST)
Received: (qmail 9694 invoked by uid 550); 31 Jul 2019 18:02:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9651 invoked from network); 31 Jul 2019 18:02:11 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=oaDZjxG3hf3XfIhJ0wNeSSq3sNs3Jdwm87Y90Lg53os=;
        b=SKwm/tKUjPhh7Ots6DumW+369InP9Y2lmV1wmGybkCv0R6omOv37Uq47RXnIirIKia
         opq8eRugeFtK7GjZou9O9XXyWH6xG8wQKJrm8VSBkDjeAeZd7tVNOdiN2FRBMB5v8ZAl
         wu+t+Jw9he5Id6CUsfAZo1ka5O7jl3A6JQT+Cxb9MRWbSOLDiBIzDKtZEeWLOiMrxS7H
         J/HZ7dbfGeZZCbYKu/XA+KgO8X9yyU23bzKjgizRsFw9qoY5zELut/2+3baGCSgZjZ+i
         XkoMqMGJ23aGab01Aws21ufDI6ctzimNBp0sOHAoQfhn71lZvFH6QPjrREDYhCjgE16y
         jsQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=oaDZjxG3hf3XfIhJ0wNeSSq3sNs3Jdwm87Y90Lg53os=;
        b=sa5rg1v4GmbUI9zm+ywSIK+20F1I4E4mtDtUTFQ9+zO8kSiKN/o61F5htrRgHX+buF
         VoOBw49TTk56ZvYbXgnA8kYHwugr76M4p1sCxbWOqAtzMylT0CV0HfmwiTGfaECuSoJ3
         /nJTDUJtk/msa2SiJFbUvRc1V50nEw7z+mYuLdIn+WhTLiAWZ2F2ZwJWh9o5/IiR9HF7
         d4RAn5MvGVkFa+7I/EnBUO2XIwQkC9TdFxZpFCvpO35Kv/FG/LccFTTbANVB7sd/3k2+
         9FNAvkt7iKZ74zeSaAZJElT4vlfsKK8CAvb/zzRLMvKllKNIBt+DyCpMAE8pycZJnRsb
         BwkA==
X-Gm-Message-State: APjAAAWIsI98oMVa/pdpRBVFQUSzRMcNPqn1j541hZgeY6CZkxj4f5P6
	O7nmaqGa+y25GQ8rFQKycsM=
X-Google-Smtp-Source: APXvYqzzGoe74Mz7GNUOaB6q/Km/WB4j0N1VMsCqKCyLVSFJnrP7Bn9v2TTLduZOyynn180hJB4tgA==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr122219821plr.68.1564596119868;
        Wed, 31 Jul 2019 11:01:59 -0700 (PDT)
Date: Thu, 1 Aug 2019 03:01:49 +0900
From: Joonwon Kang <kjw1627@gmail.com>
To: keescook@chromium.org
Cc: re.emese@gmail.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
	jinb.park7@gmail.com
Subject: [PATCH 2/2] randstruct: remove dead code in is_pure_ops_struct()
Message-ID: <281a65cc361512e3dc6c5deffa324f800eb907be.1564595346.git.kjw1627@gmail.com>
References: <cover.1564595346.git.kjw1627@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1564595346.git.kjw1627@gmail.com>
User-Agent: Mutt/1.9.4 (2018-02-28)

Recursive declaration for struct which has member of the same struct
type, for example,

struct foo {
    struct foo f;
    ...
};

is not allowed. So, it is unnecessary to check if a struct has this
kind of member.

Signed-off-by: Joonwon Kang <kjw1627@gmail.com>
---
 scripts/gcc-plugins/randomize_layout_plugin.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/scripts/gcc-plugins/randomize_layout_plugin.c b/scripts/gcc-plugins/randomize_layout_plugin.c
index bd29e4e7a524..e14efe23e645 100644
--- a/scripts/gcc-plugins/randomize_layout_plugin.c
+++ b/scripts/gcc-plugins/randomize_layout_plugin.c
@@ -440,9 +440,6 @@ static int is_pure_ops_struct(const_tree node)
 		const_tree fieldtype = get_field_type(field);
 		enum tree_code code = TREE_CODE(fieldtype);
 
-		if (node == fieldtype)
-			continue;
-
 		if (code == RECORD_TYPE || code == UNION_TYPE) {
 			if (!is_pure_ops_struct(fieldtype))
 				return 0;
-- 
2.17.1

