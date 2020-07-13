Return-Path: <kernel-hardening-return-19283-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 933C221B996
	for <lists+kernel-hardening@lfdr.de>; Fri, 10 Jul 2020 17:32:45 +0200 (CEST)
Received: (qmail 17718 invoked by uid 550); 10 Jul 2020 15:32:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 17692 invoked from network); 10 Jul 2020 15:32:39 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : mime-version : content-type :
 in-reply-to; s=corp-2020-01-29;
 bh=noRFkj+OQDbBA2VGp4VYO7xlUC6XPPINL2vE+AEdyMs=;
 b=vP7ocyP6G8yyQHxRakpibhyM1nz+c9fv0HuXARINt0xwJGXnneDkHMx3/I9UqlGe0CDP
 a0c+6nMpavkOsyuS6N4K9cIu548k77Y6U9ObDCmG20VB/170q6aRnsMcG6RUGknHH8+r
 gL78ARsbKlZWOO088PwfuNNLnqotvlsP5YvtRQJxhu7FeUTuznVOMKzuBjhEsmUA6par
 mSbZ6IlrmXcxxdg05cm4SVb2jZhgvAcpfeTaGBpmpkOaSxijP2Ub+hrjs8eVFN3bAZY+
 l6reAtwEC+XXnRCO4zxYIo4Q+OIOn2eb8IUP/uHGiLO3288Gxmm5oKDZYPQCs+3Iq53c FQ== 
Date: Fri, 10 Jul 2020 11:33:09 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Stefano Garzarella <sgarzare@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Sargun Dhillon <sargun@sargun.me>,
        Kees Cook <keescook@chromium.org>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Kernel Hardening <kernel-hardening@lists.openwall.com>,
        Jann Horn <jannh@google.com>, Aleksa Sarai <asarai@suse.de>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Stefan Hajnoczi <stefanha@redhat.com>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH RFC 0/3] io_uring: add restrictions to support untrusted
 applications and guests
Message-ID: <20200710153309.GA4699@char.us.oracle.com>
References: <20200710141945.129329-1-sgarzare@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200710141945.129329-1-sgarzare@redhat.com>
User-Agent: Mutt/1.9.1 (2017-09-22)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 mlxscore=0 adultscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100105
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9678 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 clxscore=1011 impostorscore=0 phishscore=0 suspectscore=0
 priorityscore=1501 bulkscore=0 lowpriorityscore=0 mlxlogscore=999
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006250000 definitions=main-2007100105

.snip..
> Just to recap the proposal, the idea is to add some restrictions to the
> operations (sqe, register, fixed file) to safely allow untrusted applications
> or guests to use io_uring queues.

Hi!

This is neat and quite cool - but one thing that keeps nagging me is
what how much overhead does this cut from the existing setup when you use
virtio (with guests obviously)? That is from a high level view the
beaty of io_uring being passed in the guest is you don't have the
virtio ring -> io_uring processing, right?

Thanks!
