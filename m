Return-Path: <kernel-hardening-return-15972-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 3449224440
	for <lists+kernel-hardening@lfdr.de>; Tue, 21 May 2019 01:24:27 +0200 (CEST)
Received: (qmail 21827 invoked by uid 550); 20 May 2019 23:24:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 21807 invoked from network); 20 May 2019 23:24:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XFHn2CqQ9gIGiCfwRIFED96/AC2yUgVp/k9gB9+r5g4=;
        b=OFj3iaOZ5a55OcwXkN+86bx61mb+3FqV2wabBSAGzwE20pCc5qkwj979pSL5Gslifl
         +iC/scKSpjmt8kaeRFV4EJ9dYJKeqD81EfLeDod9dCRscurIAo70YjYptk7/+jOJeyHl
         fB+eF4eIDyqqsvSOdHhKqOOVUWMHZqTcKvpGq5Iw2Ghf8Pg3bPuGyFN1RB9seQJYAdnw
         lD5mV5SHQLVWxTPf/DCac7OXGY7ABb9CrzZXn+BuLM7MomEYpmXXQeIfOaF0LMbZQVXR
         cbLj/EqbOIg7DERQzsAUYhdBCfME8nhFD/gBBsFSTQOP0zYbj2p2a8ewhPtI/TEEjeze
         hgwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XFHn2CqQ9gIGiCfwRIFED96/AC2yUgVp/k9gB9+r5g4=;
        b=mToEoihDiOnIDZTZyXGSF1wQHc0E6YNjWhkF7duaHUVhXp3bmvTAf2T7cdKddgEUpO
         cAUF3us2e0Pbi4jNp0pZELxtSTY6pBJyfrQzFfpBE6kGkz4OApCU48kFVocLbhzU//3x
         aXumsE1/v30hTPuWe5WMZw8FBfgAxyqPDXa4SviVbobrgKx+x2w3N2HcTCd15dJsM51s
         Y5cE0mW8/U62RsieE0YxtxLjrY+0aM/zQU0uvQsZLOCC83RJrDwv8wguH6NxI5gKlJIL
         8yyf17OipS0Au08FOgV/tphLkhHLXrh788EbFo3n6m5CYQ9wCvW+jO3rPMepPxWXBv4U
         SExw==
X-Gm-Message-State: APjAAAULWPnsOTZIastsrumAyLXt4tySzSvTtXa2skS8fpTrp3CJ3NSp
	ntS4On4HeGgi+KIZZ2Z9pysgYBnNe10RsCvK1EYfWxg6kBI=
X-Google-Smtp-Source: APXvYqxy4e7DPNMNpm9kxNQ/AJ/M2SyMLCx1E74a0FOLGrOJRBYTPEgnniKnIw0gU9OQyKwsEsfWnK6DxnfLuqNJhV0=
X-Received: by 2002:a02:ad09:: with SMTP id s9mr11578169jan.17.1558394649513;
 Mon, 20 May 2019 16:24:09 -0700 (PDT)
MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-3-thgarnie@chromium.org>
In-Reply-To: <20190520231948.49693-3-thgarnie@chromium.org>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 20 May 2019 16:23:58 -0700
Message-ID: <CAJcbSZEJBYOME2JqFdUxTVnb7F8uSY7PSaTDMEHf7vbEscUnbg@mail.gmail.com>
Subject: Re: [PATCH v7 02/12] x86: Use symbol name in jump table for PIE support
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>, Thomas Gleixner <tglx@linutronix.de>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Nadav Amit <namit@vmware.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Masahiro Yamada <yamada.masahiro@socionext.com>, 
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 20, 2019 at 4:20 PM Thomas Garnier <thgarnie@chromium.org> wrote:
>
> From: Thomas Garnier <thgarnie@google.com>
>
> Replace the %c constraint with %P. The %c is incompatible with PIE
> because it implies an immediate value whereas %P reference a symbol.
> Change the _ASM_PTR reference to .long for expected relocation size and
> add a long padding to ensure entry alignment.
>
> Position Independent Executable (PIE) support will allow to extend the
> KASLR randomization range below 0xffffffff80000000.
>
> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> ---
>  arch/x86/include/asm/jump_label.h | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/arch/x86/include/asm/jump_label.h b/arch/x86/include/asm/jump_label.h
> index 65191ce8e1cf..e47fad8ee632 100644
> --- a/arch/x86/include/asm/jump_label.h
> +++ b/arch/x86/include/asm/jump_label.h
> @@ -25,9 +25,9 @@ static __always_inline bool arch_static_branch(struct static_key *key, bool bran
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 ".long 1b - ., %l[l_yes] - . \n\t"
> -               _ASM_PTR "%c0 + %c1 - .\n\t"
> +               _ASM_PTR "%P0 - .\n\t"
>                 ".popsection \n\t"
> -               : :  "i" (key), "i" (branch) : : l_yes);
> +               : :  "X" (&((char *)key)[branch]) : : l_yes);
>
>         return false;
>  l_yes:
> @@ -42,9 +42,9 @@ static __always_inline bool arch_static_branch_jump(struct static_key *key, bool
>                 ".pushsection __jump_table,  \"aw\" \n\t"
>                 _ASM_ALIGN "\n\t"
>                 ".long 1b - ., %l[l_yes] - . \n\t"
> -               _ASM_PTR "%c0 + %c1 - .\n\t"
> +               _ASM_PTR "%P0 - .\n\t"
>                 ".popsection \n\t"
> -               : :  "i" (key), "i" (branch) : : l_yes);
> +               : : "X" (&((char *)key)[branch]) : : l_yes);
>
>         return false;
>  l_yes:
> --
> 2.21.0.1020.gf2820cf01a-goog
>

Realized I forgot to address a feedback from the previous iteration on
this specific patch. Ignore it I will work to check if it can be
remove on the next iteration.


-- 
Thomas
