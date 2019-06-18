Return-Path: <kernel-hardening-return-16182-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 2C16449F4D
	for <lists+kernel-hardening@lfdr.de>; Tue, 18 Jun 2019 13:36:36 +0200 (CEST)
Received: (qmail 19470 invoked by uid 550); 18 Jun 2019 11:36:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 18413 invoked from network); 18 Jun 2019 11:36:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=6BhV7F6JXtD5v5Xw+RIrHm/YuUEbdqbMPTgvUsw6Xbs=;
        b=X8PDaA/SnNrUQpc51WoQlPrnWtV0NabNQ21fZxb6QSTLSVppx3PwXfFjnSRLGFBlWl
         L6yC5KyZSUJJLZkhBdjfrILdTXxF90Cp13V+PojKW+8ag7i3bzc3c2EInBmWSVo1SKEU
         JZ9nSxXRaKED8KUzDpHO/5zNUujRKzdfIXYxiMiBoURqffe0U71LDjx5cMH+ZkKvMKfo
         DMu0VA9FqS/cG9VWJ/nfJexS6/EX+IJvw5AynLjI6p9znV0LDK4cae/20atG+76PuE2b
         5I4SAoTYcfVpc1+rde6bAFvmdcJESDM7/WAoD3hb6VO4dmGCSzjF49oXBWSnZEKZFDOI
         c5rQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=6BhV7F6JXtD5v5Xw+RIrHm/YuUEbdqbMPTgvUsw6Xbs=;
        b=brGs+OPGl+7Ha2v1Uk1CLy36rbFohy7Dw8tgNVZBVv8LtQVDVAkIfeeVUpa2ej6VnJ
         7esGQy5mFHJWAMS7KIX3QTWMGKAcVXgnE7z4eYEpSDnH7mNvDl/wI10FT3+4iyRi8HWS
         0KMXyx3PccXkukv9AHKixHo3CYibghUl0GCPiywWWC6puebRwvbUm0wMOnP6Kg2GhE8q
         2ot730KZRU+aqos9/7JNodkD4oeMVyy36CDEDIugijmZV+4iEmrmdMNUYubKgjqmTuj5
         Ll3ZwtFQlMz13WiLkbQWCXXEn0RqQDgoHTJoavUs5CAYQHH84e4rz/y3eZlQqCIaE13V
         V0mw==
X-Gm-Message-State: APjAAAVIIbGuGylPitETA2m+kwvSGYI1TSjMvwFPwy2AgyOCQl9vPw9A
	qN2+sPeudUOKdfwysXKX9ZBEKpBojLC/kQ5uCXP13Q==
X-Google-Smtp-Source: APXvYqxrRuIg9cGf4HM4v8cbX0sz5nBuwRsTbDOJatCoWHGdjZc8xcRSv2jNNz8Y/rXSLifwe7TRBqTcGuirysPaSJY=
X-Received: by 2002:a9d:774a:: with SMTP id t10mr5556953otl.228.1560857777241;
 Tue, 18 Jun 2019 04:36:17 -0700 (PDT)
MIME-Version: 1.0
References: <12356C813DFF6F479B608F81178A5615869EB0@BGSMSX101.gar.corp.intel.com>
In-Reply-To: <12356C813DFF6F479B608F81178A5615869EB0@BGSMSX101.gar.corp.intel.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 18 Jun 2019 13:35:51 +0200
Message-ID: <CAG48ez1fGhPmARDo9F_h=aX5G4eS8ti76678ynrEF0=mqXH02Q@mail.gmail.com>
Subject: Re: Get involved
To: "Gote, Nitin R" <nitin.r.gote@intel.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Shyam Saini <mayhs11saini@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, Jun 18, 2019 at 1:20 PM Gote, Nitin R <nitin.r.gote@intel.com> wrote:
>
> Hi Kees,
>
> I would like to be involved on upstream on security related topics.
> I'm planning to work on below items from KSPP to do list:
>         1. deprecate strcpy() in favor of strscpy().
>         2. deprecate strlcpy() in favor of strscpy().
>         3. deprecate strncpy() in favor of strscpy(), strscpy_pad(), or str2mem_pad().
>
> I'm thinking of following approach for above items :
>
> Approach 1 : Do we need to blindly replace strcpy() or strlcpy() or strncpy() with strscpy() in entire linux kernel tree ?
>                  (This approach is time consuming as lots of changes need to do in single patch or multiple patch)

Linus wrote at <https://lore.kernel.org/lkml/CA+55aFwHCPnPf_xs6GJu37UBvg_BSiFPH2uQps7qNNFV8Ej-SA@mail.gmail.com/>:

| I wrote a longish merge message about why - but it boils down to me
| hating the mindless trivial conversion patches. Which were not in the
| pull request, but I want to make it clear to everybody that I have
| absolutely zero interest in seeing such patches. I want to encourage
| judicious use of strscpy() in new code, or in code that gets modified
| because it is buggy or is updated for other reasons (and thus thought
| about and tested), but I am *not* going to accept patches that do mass
| conversions of strlcpy or strncpy to the new interface.

From the "longish merge message" at
<https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=30c44659f4a3e7e1f9f47e895591b4b40bf62671>:

| Every time we introduce a new-and-improved interface, people start doing
| these interminable series of trivial conversion patches.
|
| And every time that happens, somebody does some silly mistake, and the
| conversion patch to the improved interface actually makes things worse.
| Because the patch is mindnumbing and trivial, nobody has the attention
| span to look at it carefully, and it's usually done over large swatches
| of source code which means that not every conversion gets tested.
|
| So I'm pulling the strscpy() support because it *is* a better interface.
| But I will refuse to pull mindless conversion patches.  Use this in
| places where it makes sense, but don't do trivial patches to fix things
| that aren't actually known to be broken.

Unless Linus changed his mind about that in the years since then, you
probably don't want to spend your time writing a patch Linus doesn't
want.

> Approach 2 : Do we need to implement script or some mechanism which checks for functions likes strcpy(), strlcpy() or strncpy() and
>                  throw some deprecate error, if these functions found and suggest to use strscpy() ?

It would probably make sense to add warnings for strlcpy() and
strncpy() in scripts/checkpatch.pl.
