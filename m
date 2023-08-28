Return-Path: <kernel-hardening-return-21687-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by mail.lfdr.de (Postfix) with SMTP id 2F63D78B579
	for <lists+kernel-hardening@lfdr.de>; Mon, 28 Aug 2023 18:41:53 +0200 (CEST)
Received: (qmail 7555 invoked by uid 550); 28 Aug 2023 16:41:37 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 7446 invoked from network); 28 Aug 2023 16:41:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693240885; x=1693845685;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CExjtWU18myzeoEnkmxVKd6EzP/RKyiRwyVAYpgAhU4=;
        b=NDVJZ6RT/D8FqkW34apF9+v0QBrSo64gvQImGvEdpFKVyGuvoOqGk9ordde7d0O2c2
         yfg2JX/oCkv1k0mAVF4c8p0m64s5VwW63yE5N5HCeqSzvAbdMolEdg4qGHdWLhO2PAaS
         7f6rRfaIS+/QVhtrpTasImrP/y1Fm/o5fVzgSH7TuOfA3Y4yovlXm9DUMM/yFazDoaqL
         7YV7QXSPx4ULbk93xgTN29n9LISxhzCowviRTYgmFFYAoKu15aTaeo84VwOJaMsAm6ud
         IXE8XAp59UvP5Y8ebJrFswn997AZzxsOYVBRs99zDWnsl4lj232gPrNCMCOW5raFc+dF
         HpMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693240885; x=1693845685;
        h=content-transfer-encoding:cc:to:from:subject:references
         :mime-version:message-id:in-reply-to:date:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CExjtWU18myzeoEnkmxVKd6EzP/RKyiRwyVAYpgAhU4=;
        b=lk9vCB9fsgle1/ThoA1E7H74v7hDhm9EXFjoh27NvKatYq1Z90tptvxL+d74zxYByg
         x9C+o9PFsDHJk+RuwvuQL9GBOdOOz5DaOjgIT3CG6/k5qSerKQnFtodRG0tLUeycoFil
         DfXPfbcYn2clYlU6RAM3pHinYRvE014hsFTAA9VQkug0NSwNUtF/7e78xtcmaVF+4QvA
         LUhn9TggkMoifzFk8gCdqpr7dDN4QCd7c2CajVrZ1JnBhs963eV1n/pEXb1CzJ+5XswD
         615bv/mkE5FDmELGt9sJtWN7LB8pp7nzftPc+KBy1dDZ0yfP3EQxEo/vUFsWROdlaSzi
         Wx7Q==
X-Gm-Message-State: AOJu0YzcETVrKbgNjgpkAFANlURbvZLOL10lLb5CYXRxSWZWUlwFMc4t
	srXUYCg3bXPYlj2Y6Fsp7tILewbXAf4=
X-Google-Smtp-Source: AGHT+IF1IhPcsU9CdKOSxRQ8xPUT3uTuznvyy1YqQSD3AyCS41bWbTP4JDQSvwRXDUixasqc+9STSb//osU=
X-Received: from sport.zrh.corp.google.com ([2a00:79e0:9d:4:d62e:36f4:33c6:e661])
 (user=gnoack job=sendgmr) by 2002:a81:ac47:0:b0:58c:7cb1:10f with SMTP id
 z7-20020a81ac47000000b0058c7cb1010fmr804271ywj.9.1693240885044; Mon, 28 Aug
 2023 09:41:25 -0700 (PDT)
Date: Mon, 28 Aug 2023 18:41:17 +0200
In-Reply-To: <20230828164117.3608812-1-gnoack@google.com>
Message-Id: <20230828164117.3608812-2-gnoack@google.com>
Mime-Version: 1.0
References: <20230828164117.3608812-1-gnoack@google.com>
X-Mailer: git-send-email 2.42.0.rc2.253.gd59a3bf2b4-goog
Subject: [PATCH v3 1/1] tty: Restrict access to TIOCLINUX' copy-and-paste subcommands
From: "=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: "=?UTF-8?q?Hanno=20B=C3=B6ck?=" <hanno@hboeck.de>, kernel-hardening@lists.openwall.com, 
	Kees Cook <keescook@chromium.org>, Jiri Slaby <jirislaby@kernel.org>, 
	Geert Uytterhoeven <geert@linux-m68k.org>, Paul Moore <paul@paul-moore.com>, 
	Samuel Thibault <samuel.thibault@ens-lyon.org>, David Laight <David.Laight@aculab.com>, 
	Simon Brand <simon.brand@postadigitale.de>, Dave Mielke <Dave@mielke.cc>, 
	"=?UTF-8?q?Micka=C3=ABl=20Sala=C3=BCn?=" <mic@digikod.net>, KP Singh <kpsingh@google.com>, 
	Nico Schottelius <nico-gpm2008@schottelius.org>, 
	"=?UTF-8?q?G=C3=BCnther=20Noack?=" <gnoack@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

From: Hanno B=C3=B6ck <hanno@hboeck.de>

TIOCLINUX can be used for privilege escalation on virtual terminals when
code is executed via tools like su/sudo and sandboxing tools.

By abusing the selection features, a lower-privileged application can
write content to the console, select and copy/paste that content and
thereby executing code on the privileged account. See also the poc
here:

  https://www.openwall.com/lists/oss-security/2023/03/14/3

Selection is usually used by tools like gpm that provide mouse features
on the virtual console. gpm already runs as root (due to earlier
changes that restrict access to a user on the current TTY), therefore
it will still work with this change.

With this change, the following TIOCLINUX subcommands require
CAP_SYS_ADMIN:

 * TIOCL_SETSEL - setting the selected region on the terminal
 * TIOCL_PASTESEL - pasting the contents of the selected region into
   the input buffer
 * TIOCL_SELLOADLUT - changing word-by-word selection behaviour

The security problem mitigated is similar to the security risks caused
by TIOCSTI, which, since kernel 6.2, can be disabled with
CONFIG_LEGACY_TIOCSTI=3Dn.

Signed-off-by: Hanno B=C3=B6ck <hanno@hboeck.de>
Signed-off-by: G=C3=BCnther Noack <gnoack@google.com>
Tested-by: G=C3=BCnther Noack <gnoack@google.com>
---
 drivers/tty/vt/vt.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/tty/vt/vt.c b/drivers/tty/vt/vt.c
index 1e8e57b45688..1eb30ed1118d 100644
--- a/drivers/tty/vt/vt.c
+++ b/drivers/tty/vt/vt.c
@@ -3156,9 +3156,13 @@ int tioclinux(struct tty_struct *tty, unsigned long =
arg)
=20
 	switch (type) {
 	case TIOCL_SETSEL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		return set_selection_user((struct tiocl_selection
 					 __user *)(p+1), tty);
 	case TIOCL_PASTESEL:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		return paste_selection(tty);
 	case TIOCL_UNBLANKSCREEN:
 		console_lock();
@@ -3166,6 +3170,8 @@ int tioclinux(struct tty_struct *tty, unsigned long a=
rg)
 		console_unlock();
 		break;
 	case TIOCL_SELLOADLUT:
+		if (!capable(CAP_SYS_ADMIN))
+			return -EPERM;
 		console_lock();
 		ret =3D sel_loadlut(p);
 		console_unlock();
--=20
2.42.0.rc2.253.gd59a3bf2b4-goog

