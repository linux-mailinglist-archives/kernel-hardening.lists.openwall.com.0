Return-Path: <kernel-hardening-return-19086-lists+kernel-hardening=lfdr.de@lists.openwall.com>
X-Original-To: lists+kernel-hardening@lfdr.de
Delivered-To: lists+kernel-hardening@lfdr.de
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.lfdr.de (Postfix) with SMTP id 7F0CF206D90
	for <lists+kernel-hardening@lfdr.de>; Wed, 24 Jun 2020 09:25:29 +0200 (CEST)
Received: (qmail 9811 invoked by uid 550); 24 Jun 2020 07:25:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Delivered-To: mailing list kernel-hardening@lists.openwall.com
Received: (qmail 9791 invoked from network); 24 Jun 2020 07:25:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZLkF71JTsTxhhhiydtS3Dg3wcvXwv7lzeN1c+2LHTkY=;
        b=WAZ4doPa04qJ8iercAU2kv0gGs9+d0zRO+9jTotCyRd1mUumDg6pjjtJJbAqaOXV1f
         IzGN3l1C41FxYt2/9Q9RwmWb4Bp5WOXeEyyA5OAvCmhz/RdqRrlORZmZMjpbFRdElhH+
         l9bcuI7JNngNM/rwemvFrHhTFWgmEpdXa3QS4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZLkF71JTsTxhhhiydtS3Dg3wcvXwv7lzeN1c+2LHTkY=;
        b=DvfVAflmPm7WyXVPnKWJiQZ8v7ffIJXUGtsDUagByTNtuwjjJJLnaWVl4deKCFkk4B
         +gUSBhJpWc6Ss95JdGhzLhFmme1BPR9iJTp+2bQDWohPkcnd4Gjrbc7nfU4Oy4G5VAv7
         v2WBf126z5C94iyV1ldrjOxmh/o35XDAYPl7LRiABI5VsmNgxojIyOY4HmXWWjgoNb/C
         r6WPIaIoAO4LX7NrdGaQ7rz/prMfoE4BvWnMN80431a9GjSuJsYLrwb4JiDlku9oplH0
         cqQt5LQmti6tas/lc+dBYSfucYLGyW4yLN9emo/MoV7q26x7cYrRpHT6HAWcr7+w9NFF
         qUTA==
X-Gm-Message-State: AOAM530JFIQVC1Is1B/UT4Hxn+NnbBzNJS0ZPbv328HkAsIAFmS/d2OA
	7HEAoTvo0pgRBm65QEdhGsg5n1JWoRg=
X-Google-Smtp-Source: ABdhPJyI1eeUVqQVvX6PwmU1zR/wkoa+/6wYGM6Zr5x61cPl17IX/K26RULodS2LBOkVqvoXWv1Thg==
X-Received: by 2002:a17:90a:356a:: with SMTP id q97mr12932118pjb.213.1592983511481;
        Wed, 24 Jun 2020 00:25:11 -0700 (PDT)
Date: Wed, 24 Jun 2020 00:25:09 -0700
From: Kees Cook <keescook@chromium.org>
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de,
	arjan@linux.intel.com, x86@kernel.org, linux-kernel@vger.kernel.org,
	kernel-hardening@lists.openwall.com, rick.p.edgecombe@intel.com,
	Tony Luck <tony.luck@intel.com>
Subject: Re: [PATCH v3 09/10] kallsyms: Hide layout
Message-ID: <202006240022.E5FB4E08F3@keescook>
References: <20200623172327.5701-1-kristen@linux.intel.com>
 <20200623172327.5701-10-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200623172327.5701-10-kristen@linux.intel.com>

On Tue, Jun 23, 2020 at 10:23:26AM -0700, Kristen Carlson Accardi wrote:
> +static int kallsyms_open(struct inode *inode, struct file *file)
> +{
> +	int ret;
> +	struct list_head *list;
> +
> +	list = __seq_open_private(file, &kallsyms_sorted_op, sizeof(*list));
> +	if (!list)
> +		return -ENOMEM;
> +
> +	INIT_LIST_HEAD(list);
> +
> +	ret = kallsyms_on_each_symbol(get_all_symbol_name, list);
> +	if (ret != 0)
> +		return ret;
> +
> +	list_sort(NULL, list, kallsyms_list_cmp);
> +
> +	return 0;
> +}

Oh, wait, one thing! I think this feedback to v2 got missed:
https://lore.kernel.org/lkml/202005211441.F63205B7@keescook/

This bug still exists, and has the same solution.

-- 
Kees Cook
