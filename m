Return-Path: <kernel-hardening-return-17341-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id D9324F8711
	for <lists+kernel-hardening@lfdr.de>; Tue, 12 Nov 2019 04:17:16 +0100 (CET)
Received: (qmail 25973 invoked by uid 550); 12 Nov 2019 03:17:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25939 invoked from network); 12 Nov 2019 03:17:10 -0000
Date: Tue, 12 Nov 2019 11:16:35 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Stephan =?iso-8859-1?Q?M=FCller?= <smueller@chronox.de>,
	Kees Cook <keescook@chromium.org>,
	=?iso-8859-1?Q?Jo=E3o?= Moreira <joao.moreira@lsc.ic.unicamp.br>,
	Sami Tolvanen <samitolvanen@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>, x86@kernel.org,
	linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v4 3/8] crypto: x86/camellia: Use new glue function macros
Message-ID: <20191112031635.jm32vne33qxh7ojh@gondor.apana.org.au>
References: <20191111214552.36717-1-keescook@chromium.org>
 <20191111214552.36717-4-keescook@chromium.org>
 <3059417.7DhL3USBNQ@positron.chronox.de>
 <20191112031417.GB1433@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112031417.GB1433@sol.localdomain>
User-Agent: NeoMutt/20170113 (1.7.2)

On Mon, Nov 11, 2019 at 07:14:17PM -0800, Eric Biggers wrote:
>
> Also, I don't see the point of the macros, other than to obfuscate things.  To
> keep things straightforward, I think we should keep the explicit function
> prototypes for each algorithm.

I agree.  Kees, please get rid of the macros.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
