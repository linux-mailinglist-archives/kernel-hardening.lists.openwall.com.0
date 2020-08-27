Return-Path: <kernel-hardening-return-19677-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id C51F5253D37
	for <lists+kernel-hardening@lfdr.de>; Thu, 27 Aug 2020 07:25:40 +0200 (CEST)
Received: (qmail 9529 invoked by uid 550); 27 Aug 2020 05:24:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9355 invoked from network); 27 Aug 2020 05:24:45 -0000
From: "Christopher M. Riedl" <cmr@codefail.de>
To: linuxppc-dev@lists.ozlabs.org
Cc: kernel-hardening@lists.openwall.com
Subject: [PATCH v3 2/6] x86: Add LKDTM accessor for patching addr
Date: Thu, 27 Aug 2020 00:26:55 -0500
Message-Id: <20200827052659.24922-3-cmr@codefail.de>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200827052659.24922-1-cmr@codefail.de>
References: <20200827052659.24922-1-cmr@codefail.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: ClamAV using ClamSMTP
X-Originating-IP: 198.54.122.47
X-SpamExperts-Domain: o3.privateemail.com
X-SpamExperts-Username: out-03
Authentication-Results: registrar-servers.com; auth=pass (plain) smtp.auth=out-03@o3.privateemail.com
X-SpamExperts-Outgoing-Class: ham
X-SpamExperts-Outgoing-Evidence: SB/global_tokens (0.00988328726046)
X-Recommended-Action: accept
X-Filter-ID: Mvzo4OR0dZXEDF/gcnlw0fJi3Ojdyt5h9PLOIGvr3lipSDasLI4SayDByyq9LIhVoMTMy/X6pyNr
 Gb/FW2b+jUTNWdUk1Ol2OGx3IfrIJKyP9eGNFz9TW9u+Jt8z2T3Kq02yUY2BU41HLqp9U+7si8M8
 LdvJpZ7k99Lvu8YZXeI6p5bbhGYzvfahQ7X4A9L0Ye/JicEYVQv1wTfnWwJUGLoHT+TiZ2cHCmVO
 a6Hj9ohKUEMdSe7EvQ2LmvIpJjdQJODXbtOodkPED+RkHjVGH2xZ/WG2ZLv5RT/cF5Q6687AHRjU
 JmjnvGEokRBTZJpViFKfD1jKgYfH+6S5qDVYoHta8E9ScH7TtyK/xsUDPODbhw3Crbac1ieeuRax
 ITFpzO11BRKqT8B4uLrn7iz8uvLBMzbIQcSG8L0jOzL80Q1MxDcqDeEvahfPkDkTlH91LgaQnmF8
 H6pa6B8MTK1ligAJ9G0GMvMSOAhk0taEj8weJNI+C0vMCMVtmGEXbiaCRPGqg4v6OwYy/yt5Cj+T
 3txbXpCgbiKBsA+Ddi6maweYdUirBly/K12a4uqqibUj/dHBojDbLVZkEx6TcwTT039q0aZI3qbh
 XsaDdLgW9brs8lq6YeUVTmb2st+aVE9JYOaeuiH/yEdZH8S1+TgcJBOjh0vPxcQOjKKOrYIQYpwa
 mUdylUIKhf3z2GAHxH7IMNrut00GZ5qvF8IF7tMR72KEsztVVBDOPEFKS2UxZBZDGO6iIQJwM5Rw
 VSHiNllowov2GavqJ07j7hZY8mVbefiuK2KN35hXmy7nXQ2QuBuxX4OQOI/UQ6jnFfMBgzwOw1To
 H/cUtROfGg27pVfRPjU3fSpvtX7kDRT+AqQr2T3rxJw/s9JEmzH0m3M+UGtqDfkBjIvvy6OYDiIm
 hhRfemivBolEzt6VXB2TTRsq0ulDPDo3pDJlUlQ25PasjIMI9uAIvgWsH+Wq0zDLDi3S8euO5TcD
 eKjrEmYPn2IVWRsZR6NeDQwp7lDA8K9tDm+p97/T4LRRVYxF+VXiiOfHJN40eTXlWiUAYdLmsJdA
 oPKCpWwKtkkGG+bEnfOEkWTNI3SjTCvjMfNBc9ze9o81pXKSQ+GI7QB7PH97h6/L6Wb57LVs51cV
 C2TOjdXlLnr1FFwa8AyQYqjO7qYtiXb+9Q==
X-Report-Abuse-To: spam@se5.registrar-servers.com

When live patching a STRICT_RWX kernel, a mapping is installed at a
"patching address" with temporary write permissions. Provide a
LKDTM-only accessor function for this address in preparation for a LKDTM
test which attempts to "hijack" this mapping by writing to it from
another CPU.

Signed-off-by: Christopher M. Riedl <cmr@codefail.de>
---
 arch/x86/include/asm/text-patching.h | 4 ++++
 arch/x86/kernel/alternative.c        | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/arch/x86/include/asm/text-patching.h b/arch/x86/include/asm/text-patching.h
index 6593b42cb379..f67b4dd30bf8 100644
--- a/arch/x86/include/asm/text-patching.h
+++ b/arch/x86/include/asm/text-patching.h
@@ -148,4 +148,8 @@ void int3_emulate_call(struct pt_regs *regs, unsigned long func)
 }
 #endif /* !CONFIG_UML_X86 */
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu);
+#endif
+
 #endif /* _ASM_X86_TEXT_PATCHING_H */
diff --git a/arch/x86/kernel/alternative.c b/arch/x86/kernel/alternative.c
index c3daf0aaa0ee..c16833f35a1f 100644
--- a/arch/x86/kernel/alternative.c
+++ b/arch/x86/kernel/alternative.c
@@ -843,6 +843,13 @@ static inline void unuse_temporary_mm(temp_mm_state_t prev_state)
 __ro_after_init struct mm_struct *poking_mm;
 __ro_after_init unsigned long poking_addr;
 
+#ifdef CONFIG_LKDTM
+unsigned long read_cpu_patching_addr(unsigned int cpu)
+{
+	return poking_addr;
+}
+#endif
+
 static void *__text_poke(void *addr, const void *opcode, size_t len)
 {
 	bool cross_page_boundary = offset_in_page(addr) + len > PAGE_SIZE;
-- 
2.28.0

