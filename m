Return-Path: <kernel-hardening-return-19292-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id DD54F21D2BD
	for <lists+kernel-hardening@lfdr.de>; Mon, 13 Jul 2020 11:25:51 +0200 (CEST)
Received: (qmail 14016 invoked by uid 550); 13 Jul 2020 09:25:46 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 13981 invoked from network); 13 Jul 2020 09:25:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mfjt+rT0LYL8M4sgmWneFOp+iGUVCuq3mFYeIhVzkp4=;
        b=hNA5J16QLVtzFa9J39Jk+eyw+DNaeCMZkWN6AGE5IpWmbMa/kcgEgU4hdIRNIpRprO
         Hj0CPDV9B4EJ19k/szajI4PcmmZdaG2Me/At/c6rE5nRoC9bXspwMLqNzfxXPB3ZwJC8
         XTKsNx+umfq6LHu2Sg71oMMeZ/oMbWq9mZIsHQKYQI4v22R7EZTmSwNYvetMhmiu4sS0
         JUYW9iswhcWNDfesVoRxPbF7QXWJ0jYcU7DcCYO07uoC5Sd5JiD90obXb0D5jXbsOZ6W
         RXXvB5ncJrRcgGXNjD5STou9Ap9LTd5WXpqXZwfrHfq4cI4QZTctwmt+N0DzKGTBweZT
         hsHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mfjt+rT0LYL8M4sgmWneFOp+iGUVCuq3mFYeIhVzkp4=;
        b=LOCNcR5uWgErhLITOXEsUfn2fFQmnO7C+ULLoD/+irOlLnIgM7sM7BPirvUxP3cVkZ
         GRKTNJksl4doEPl+axgOhP44rSliAkg83sLBZk0Td4iRnDRp5ditmCZH5FREwHwnekSP
         XR2lT27Wg5EQOcqvqTSQSsAt5lYsfT2IFbsAnc/832scTZeiYvQgywVmqgMzEhY+2IrS
         BMTviIZUCH3lSiIK1c2KowX0z6iIwLscWjk6PssOuc3fZqGzBV6nz28f05pDdr5u78L+
         3hU5mPHvQvLWh/YcH/TY2hGT0eS0FcwrrZvzq1MXXo+jJYBPx1D4lVXK9vi324mm4If8
         Gqng==
X-Gm-Message-State: AOAM531OXGeRZNc3reGr/f5ONafjUQ3xeLgdJvDkeOdXmfbeEwAyQOZF
	Tt96pXX/xt+tg6KGBAkrm9arO4UG/THtCAKkfYg=
X-Google-Smtp-Source: ABdhPJzAElJh82uwvlfDG6qlwg286UiCsRRJtlYOqGTY5M8Z9b9ezjko49wDEOnRlGxcbH70J8oAQ31YvHv2gkeoIm4=
X-Received: by 2002:aca:6c6:: with SMTP id 189mr12655564oig.134.1594632333766;
 Mon, 13 Jul 2020 02:25:33 -0700 (PDT)
MIME-Version: 1.0
References: <20200711174239.GA3199@ubuntu>
In-Reply-To: <20200711174239.GA3199@ubuntu>
From: Allen <allen.lkml@gmail.com>
Date: Mon, 13 Jul 2020 14:55:22 +0530
Message-ID: <CAOMdWSLFSci1DCMsQLBoX-ADP0cHbhudfvRKokdM+pEQEfpnAQ@mail.gmail.com>
Subject: Re: Clarification about the series to modernize the tasklet api
To: Oscar Carter <oscar.carter@gmx.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Oscar,
>
> I'm working to modernize the tasklet api but I don't understand the reply
> to the patch 12/16 [1] of the patch series of Romain Perier [2].

 Am working on the same too. I did try reaching out to Romain but not luck.
Let's hope we are not duplicating efforts.

> If this patch is combined with the first one, and the function prototypes
> are not changed accordingly and these functions don't use the from_tasklet()
> helper, all the users that use the DECLARE_TASKLET macro don't pass the
> correct argument to the .data field.
>
>  #define DECLARE_TASKLET(name, func, data) \
> -struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), func, data }
> +struct tasklet_struct name = { NULL, 0, ATOMIC_INIT(0), (TASKLET_FUNC_TYPE)func, (TASKLET_DATA_TYPE)&name }
>

 Ideally this above bit should have been part of the first patch.

> The data argument is lost.
>
> If this patch is splitted in two, the first part will build correctly since
> there are casts protecting the arguments, but it will not run correctly until
> we apply the second part.
>

I have a few more things to complete, I shall have it done and pushed
to github. Will write back
once that's done.

- Allen
