Return-Path: <kernel-hardening-return-18745-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id E7BCD1CCC3B
	for <lists+kernel-hardening@lfdr.de>; Sun, 10 May 2020 18:32:28 +0200 (CEST)
Received: (qmail 26608 invoked by uid 550); 10 May 2020 16:32:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Delivered-To: moderator for kernel-hardening@lists.openwall.com
Received: (qmail 13959 invoked from network); 10 May 2020 16:12:24 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.fr; s=s2048; t=1589127130; bh=hoSSJQq0JWCyGwPoM0tISkHWN+wq3rbjti4FmGFu/yM=; h=Subject:To:References:From:Date:In-Reply-To:From:Subject; b=qoeUm5A6lYEEHu0ZdT1c/1cWx+NcZgcAk+plGfNrTwaK8A2N/ZtqF9bFlQSNVJwnQC3AuzHZW2FcNbPlTCjfVWC28AMOUuT4f5GCJK7ncBiyUTE1WrmmbGlMbdAVjQWPpOAlYAE4BN/BwrIqeXxPvMm2UO08UCzupgh1nm99WzgQiBYsgbcdbn4hKse0+jG//2c5FMaVfbx0B+uqwtuNFVloPCnkp4L/A/1i+IARutt68UoL5OUyKInnCTK52iejMLQKAH6eWQelg5tzUSVI3bAqYhpUsLkhgbzZCKGEwzx3FQgX7Rp7azkjUy8TShd/Q+Q9YRfAbWxF2N+pnFb9VQ==
X-YMail-OSG: SBlfqXIVM1n6_0Ikm8dnAD_P_gmtEp0bQpdDIa785v02tVRZN6vJgdXRh4wQwnM
 aZS2mW0FFNNqQI2y5fVU4kB1tsw2Us7rIxMczVk6G_bPfe4Z9dFl9Z9tnLoJZCh41vDWIZppAgjJ
 l_c1DHQtztSQjt41H1wrctCwXyZUkhqlI9Yk5OJaik06p2Rd_3r8iiip3HqcAZ.IoT76d5LISygU
 FJjfG.0uKBX.B86fAOe0OlG1NXZbOAyM33GqVXYRdHbmj3nKHwgztzWoZnf9mbVa37lLmPfk5qpM
 ctpe7xp4ldd4m3xfRXGhuYhE0w8kOo31LjbneQI5ccvW70D38tYcTdAOxqc5aL1G0iKIXg2flod9
 4ydKTRhLJOucuogryBvt7RHRbLNSC7723.yfStXbzsozxSUSbbw5W9K5MXd4a0ZwFCVZoij19FOB
 xuA_E2wyzEgcivS0ON6MiZD96buNwcUOO8q0ii19jS0p.tobkzrUVAt0z0puBs4028lrZJVRyCBl
 GqQV03eRgv1VZ2pyjLBiBL1fUiGhLiHxDRlYvYnS751aPK0HJk7ftdrxQPqBtJq8Twa9tPKJ8acZ
 BNXLb0Ma8HL7QRWYGhvS4nAwCNVUIV1RGNfZamMmnmh3kCDzeQHgmPLJildSyYAtPe3_MZI21cKM
 1x4l9vEANqaErWRszi8sXENidYkArFcIln68OeJqtYhliT72lufzGUxPH8IQs0YYQcKX3.eHOkTj
 LpknsqhZDEIZP3lkLSFWSIjowAqR3uXiZ4F4Bqbh1eRKtbfEVRsjyY85CrLuxr__cOMhCASLJdn3
 FzFs46MjoSxyeTAV0xBOnlrP10trqKMwUfrtjC9cetLTXxdamwapp_ihh.E1lJMQQk2r7aN0Ok0F
 aaYoOlEOsXlk_huu3L2QJEiHHY1odc3HCjOrc9HqsmwzPGGIwGAui904iP1Esn_d8M77xJpI1cB5
 EnVH5SYJgkGaNh0R6Vgt6tkAQwOucSYH7EneoE8IyTaGJ.MSMXDsgzDODfUHbv_McHR.9tdGr3Ht
 KPgK2D_8z_EkUzxVNAUGcYOo5wIJUAFZVp7oQqFjurVO9kSSlRnKOUatncHifrSw.63x9haRmcg3
 nNQxc3KI7L_vW7rcDQlDQI2krbUS9NLk97tcF_h_41ftT3UGf0HxjubvgqwvyIoAlqIYHHQfnDx.
 XIepVAsilSQDJmr7ZhVvCs2GepxiTs1VPH5HBrfLYPF2TS.ftFIYpl2ZwzBVyTrvRDce_adfbold
 lwNFDqsnS7lsiSHutje5FbuBJ13ChnSSyOd7ZvTa8T_G6YjX7BwnhmxmsZhnyJEl9KERa2WY2k4e
 HVcE4MedVKFWrqL4JjvQaHtfErGxRFJd303gpUeIMsafx_Vy3h0y6yABWRV0Yd7ZDa8qIa2K0yxu
 e.ttmOus.vNHYdUK4bpeHf2K35eSxyZ6ZHWNuVmkSFD388zx4KRbxKHhmW9wbsqLhoA7wegLAsZU
 SkXQaUC9OvYWhF1_FR2ktqsFC1CY1
Subject: Re: Open source a new kernel harden project
To: kernel-hardening@lists.openwall.com
References: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
From: Lionel Debroux <lionel_debroux@yahoo.fr>
Message-ID: <62f8bcee-ac3c-e344-b95e-18ef86903f55@yahoo.fr>
Date: Sun, 10 May 2020 18:12:06 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:76.0) Gecko/20100101
 Thunderbird/76.0
MIME-Version: 1.0
In-Reply-To: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.15902 hermes Apache-HttpAsyncClient/4.1.4 (Java/11.0.6)

Hi,

 >      This is a new kernel harden project called hksp(huawei kernel
 > self protection),  hope some of the mitigation ideas may help you,
 > thanks.
 >      patch: https://github.com/cloudsec/hksp
 > [...]
See also
https://grsecurity.net/huawei_hksp_introduces_trivially_exploitable_vulnerability


Regards,
Lionel Debroux.
