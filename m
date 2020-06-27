Return-Path: <kernel-hardening-return-19183-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 8C87620C1DC
	for <lists+kernel-hardening@lfdr.de>; Sat, 27 Jun 2020 15:45:11 +0200 (CEST)
Received: (qmail 15646 invoked by uid 550); 27 Jun 2020 13:45:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 15625 invoked from network); 27 Jun 2020 13:45:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
	s=badeba3b8450; t=1593265462;
	bh=lFWXqdePd4DyXgNpm31xytWm1F1ZN/XcJboKFJ2akTc=;
	h=X-UI-Sender-Class:From:To:Cc:Subject:Date;
	b=U5oGykqjhCeWQ6VOBTNmh03M6XCAm+pD09uH4+T7DrDwY1SKQhxbtOL/ABnStEa/S
	 PfoTVIE0VA04JG9UkzA1YktiDtrzAYLz9JeFpb2MCwwMNzeA6fREx2Q9KuzMHPOy5C
	 4OSneFLG1uqkqFNYxcRHmqoVLVQnPbxaES8rt2oI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
From: Oscar Carter <oscar.carter@gmx.com>
To: Kees Cook <keescook@chromium.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>
Cc: kernel-hardening@lists.openwall.com,
	linux-parisc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Oscar Carter <oscar.carter@gmx.com>
Subject: [PATCH] parisc/kernel/ftrace: Remove function callback casts
Date: Sat, 27 Jun 2020 15:43:48 +0200
Message-Id: <20200627134348.30601-1-oscar.carter@gmx.com>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:wIA4UEOVrMPBixJrC6vud+7JWju+3dUuA9dgRmOulVfkomqN98k
 J686MFh0NZuXx/c979VCYvyYbzDfk2va4O6y6reWPq02BtPDMcl5z718wLB3jUZSdt51xSI
 VxifaDCeidc4XqZTDBYctS5uThXMfngzbm8w6w59pLFMUNO6WB8X1mfgGPi47RxiOthkzqE
 rZnnXYY3g3OktLNANK8Fw==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:+bxAtbELlTU=:AIVXJGBmVMIT65YrALMuS8
 SKARVtgwT6z9XLB+mawgeRIbj0E7ldANgLcChrGyzj7rIenKH5VEMbIqOWLIesYkeOxXquZoD
 7jer8nKfPuNEl3mQpi6UPgJZs9b9K8uO9sxL/nSGS82dhTHNlKy+z46COcerbravGzKPjtJM7
 89Rpwj3GU6l+JY/oJ7HK4AUnsddckYU7s0I5lZXrmK9reSioubHrIIO7/0WN748hLzKL5YtRq
 6tyrG3k6QTxD+v7nwV2sFp8mf+2o8d3ETUFnELAnw8y0W6l7pkbUdpfnIl7b1ooUTcDdPbjdT
 P8OvyCur47xAO6eBfQV4OBN2FZvUtOQj38hgdKUy1WWDbyR2mx6hjkBxvY8FFFCXabH/B16FQ
 4h40iXu+afncRyB6XQoH0bhmn7wG+lGUQFgbTojkE8Qr8ydlIipAm3nzpCzbIr32c+JXkutff
 +n5ArbwBkHUv15tEGZwK4kkaYUtN7MPARtWLpw4S9h6zst3sH765BSAOgyI7BPTvmYrdCQA5u
 bC1J9DW+kIbIt+wHB8YfMqYLGDo7SVApVDQrbFRA3DSicRi95alGCJaVy/XSwOIGg1s7Up0J/
 iVgjv+i4wpCNO1sAAp2VGSI0ja8osyzgFJEJ8fETrTXcqFtl82wopajFFGW8aaHatA7q27p65
 fkyskIbY6OktGhl8B2JqDpc69rw9WsXLkCLDsyCn+D/UQA6xoGMhyDPIthUFjaOyFZ102rDfB
 oKIRs4OlYx6RFyTUms9ymo2+WoPTxoEFpCI+EyDKg8MZ4xxftdnBLs411Gscofwg+pPnwDfXU
 uZZHF1PoGAUHVUOuJCrR2Qwsmzl3CSENblP8VXcsNeVSB/dOtoyOR7Vgqn1OdaBKLD+5J5kdA
 rydtWW7LkBtpkC5fMukERaKfFqOSQ4z3qVsOaPRUMCsMd2JxCU2hR4oVEGQtZScgJCJJOTyZ/
 lzFYO/7KLg9UqjyPjJ332wL1ljFooR48m108euwoN6m4p+idHtFxvIYv05FgXUVNQMhA15mMu
 3Gl27uha8kIgM3Za3URdV9riEUBMI5UwFXQ4VrZi/KcXzOcYqdKsN5avw3RkLEeNbPzt8hin9
 Dy6RfQ/N6f4GYSWT00QPU7q5Y38jp1NSJ8pK4uVD+4aHPnmxcth4UPKZjcDURYLTMswkgDudk
 J694lY5ivXx4PHgJyHnev0QFBLuTRfCx5tvzmmxelBg6RVcRkc9oEMrCQph63Zc/QjBLYXq2n
 Q4KjZA5K9R7yBeJXC

In an effort to enable -Wcast-function-type in the top-level Makefile to
support Control Flow Integrity builds, remove all the function callback
casts.

To do this remove the cast to a function pointer type in the comparison
statement and add to the right and left operand a cast to unsigned long
type. This can be done since the comparison is against function address
(these operands are not function calls).

Signed-off-by: Oscar Carter <oscar.carter@gmx.com>
=2D--
 arch/parisc/kernel/ftrace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/parisc/kernel/ftrace.c b/arch/parisc/kernel/ftrace.c
index 1df0f67ed667..86b49a5fc049 100644
=2D-- a/arch/parisc/kernel/ftrace.c
+++ b/arch/parisc/kernel/ftrace.c
@@ -64,7 +64,7 @@ void notrace __hot ftrace_function_trampoline(unsigned l=
ong parent,
 				function_trace_op, regs);

 #ifdef CONFIG_FUNCTION_GRAPH_TRACER
-	if (ftrace_graph_return !=3D (trace_func_graph_ret_t) ftrace_stub ||
+	if ((unsigned long)ftrace_graph_return !=3D (unsigned long)ftrace_stub |=
|
 	    ftrace_graph_entry !=3D ftrace_graph_entry_stub) {
 		unsigned long *parent_rp;

=2D-
2.20.1

