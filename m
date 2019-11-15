Return-Path: <kernel-hardening-return-17373-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 42A91FD72C
	for <lists+kernel-hardening@lfdr.de>; Fri, 15 Nov 2019 08:43:41 +0100 (CET)
Received: (qmail 25869 invoked by uid 550); 15 Nov 2019 07:43:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 25829 invoked from network); 15 Nov 2019 07:43:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2019-08-05;
 bh=g8uThl8dkg+cj+2qFvpX4UHz2ZpNIXnP5NoBMB9GLqg=;
 b=ZH1elWzwIglBNSmcB5X+wP0yf/LmUt1gwQ+BKmeAdqrKDHpR/B3VCP4gZCn+KMqZMs9o
 VGHfMyBeXTtqPWxiohoxTx5o7AfdSifH5au/Bm2F7yVdLrt3SFvNiIu3Bmkqjm2Sh1FQ
 PezEvg+YOhnSG5jhEdCiE5XV3iqHQhA9DYdcDAsrS43yoJzICjQ8HGET00MD1DelpZ0X
 M+etngT3aPLHcBKyusqkOVVWdOf2MdHXjY7n+YHRfOY5MAx7YFmUmeiVh70iLUsFIgRv
 KCSZWILoTsg5EdUjbLSi1zTrjbonXuFcKjTLQm2+RS4ZrBxPO9YIBIsDHfdo4Swj/sjF Qg== 
Date: Fri, 15 Nov 2019 10:40:03 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kees Cook <keescook@chromium.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>,
        kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
        Romain Perier <romain.perier@gmail.com>,
        Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl*: Remove tasklet callback casts
Message-ID: <20191115074003.GB19101@kadam.lan>
References: <201911142135.5656E23@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201911142135.5656E23@keescook>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1911140001 definitions=main-1911150069
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9441 signatures=668685
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1911140001
 definitions=main-1911150069

On Thu, Nov 14, 2019 at 09:39:00PM -0800, Kees Cook wrote:
> In order to make the entire kernel usable under Clang's Control Flow
> Integrity protections, function prototype casts need to be avoided
> because this will trip CFI checks at runtime (i.e. a mismatch between
> the caller's expected function prototype and the destination function's
> prototype). Many of these cases can be found with -Wcast-function-type,
> which found that the rtl wifi drivers had a bunch of needless function
> casts. Remove function casts for tasklet callbacks in the various drivers.
> 
> Signed-off-by: Kees Cook <keescook@chromium.org>

Clang should treat void pointers as a special case.  If void pointers
are bad, surely replacing them with unsigned long is even more ambigous
and worse.

regards,
dan carpenter

