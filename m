Return-Path: <kernel-hardening-return-15883-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D51E0155FA
	for <lists+kernel-hardening@lfdr.de>; Tue,  7 May 2019 00:20:27 +0200 (CEST)
Received: (qmail 30685 invoked by uid 550); 6 May 2019 22:20:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 30665 invoked from network); 6 May 2019 22:20:22 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LFigoZJymqmAaPzjvAFIhkqDgKas3FocYI4lCQ70qnE=;
        b=ABG4sOkPQqPowCgFecCPGKupz44mONVpCKnynPqbD1PBGzbJqzFzk7rgRpOY/O+YM1
         Trx119D7VlwsARtPhJ2zsjkzziHTWrE0bXmWqFXdHnEDiyHV+Vn05EYT4zYqTMg6yNcq
         d+IBEMobGQ+IHeDSQ4cy77I4r/gGPKXy6dXWw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LFigoZJymqmAaPzjvAFIhkqDgKas3FocYI4lCQ70qnE=;
        b=bQL6mge5u+AFCEPbRCGmanV8I4mpZVcGMeVh5Gg2lErFd8dFpCY3SquCSC+2XMVDOT
         xyMuNGCQD5ouk/BG5I3IAWjmVLs6yS7+h+CVGvnBrk9YOSAH1UaK/z7fpiuIzqGflmcx
         Dyam+vsCNWLsbRi0Coc0BJxNn5jvNZ07qTyuQoDciP5W8W9KCbmavteUo37tEGzun3/n
         gV7S5rFquxL0fpBcx2mgdhLqPGJ5VBd5dDifuIli+CfmwoedWY96w4N6EAhKjW39MDKf
         PQ0RDi47PF+X8fHa04h7IBaP9NqTwTTwLqAN3jrjD3laF8nKWm/C8FAIyoptky3eezWI
         CazA==
X-Gm-Message-State: APjAAAWgh4VBCm89HAlCpACjbMDlzZkEM/LBMRLacXx2u8skHI3t2RB0
	/bXccGoLUL0WbHY1SR03n/1U66OEM7c=
X-Google-Smtp-Source: APXvYqzdgtz28vThXUpIwssbzUL6IMSaztIelhryzN2j/6DD2yBqtMmWlUjnQFEzKZD8cdYUOO90iw==
X-Received: by 2002:a1f:3a14:: with SMTP id h20mr3238423vka.52.1557181209005;
        Mon, 06 May 2019 15:20:09 -0700 (PDT)
X-Received: by 2002:a05:6102:397:: with SMTP id m23mr5277776vsq.222.1557181207040;
 Mon, 06 May 2019 15:20:07 -0700 (PDT)
MIME-Version: 1.0
References: <20190506191950.9521-1-jmoreira@suse.de> <20190506191950.9521-4-jmoreira@suse.de>
In-Reply-To: <20190506191950.9521-4-jmoreira@suse.de>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 6 May 2019 15:19:55 -0700
X-Gmail-Original-Message-ID: <CAGXu5jKt9NuGeHumTkO2aD1MoBdP-OwRTXu1_qq0r8_t=Y6sMw@mail.gmail.com>
Message-ID: <CAGXu5jKt9NuGeHumTkO2aD1MoBdP-OwRTXu1_qq0r8_t=Y6sMw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/4] Fix twofish crypto functions prototype casts
To: Joao Moreira <jmoreira@suse.de>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, 
	Greg KH <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, May 6, 2019 at 12:20 PM Joao Moreira <jmoreira@suse.de> wrote:
> RFC: twofish_enc_blk_ctr_3way is assigned both to .ecb and to .ctr,
> what makes its declaration through the macro undoable, as thought in
> this patch. Suggestions on how to fix this are welcome.

This looks like a typo in the original code (due to the lack of type checking!)

typedef void (*common_glue_func_t)(void *ctx, u8 *dst, const u8 *src);
...
#define GLUE_FUNC_CAST(fn) ((common_glue_func_t)(fn))
...
void twofish_enc_blk_ctr_3way(void *ctx, u128 *dst, const u128 *src,
                             le128 *iv)

static const struct common_glue_ctx twofish_ctr = {
...
               .fn_u = { .ecb = GLUE_FUNC_CAST(twofish_enc_blk_ctr_3way) }
...
        return glue_ctr_req_128bit(&twofish_ctr, req);

int glue_ctr_req_128bit(const struct common_glue_ctx *gctx,
                        struct skcipher_request *req)
...
                                gctx->funcs[i].fn_u.ctr(ctx, dst, src, &ctrblk);

The twofish_ctr structure is actually only ever using the .ctr
assignment in the code, but it's a union, so the assignment via .ecb
is the same as .ctr.

-- 
Kees Cook
