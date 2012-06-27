
class nslcd ($ldap_nss_uri,
			$ldap_base,
			$ldap_binddn,
			$ldap_bindpw,
			$ldap_base_users,
			$ldap_base_groups)
{
	package { "nss-pam-ldapd" :
		ensure => installed,
	}

	file { "/etc/nslcd.conf" :
		owner => "root",
		group => "root",
		mode => 600,
		content => template("nslcd/nslcd.conf.erb"),
		require => [Class["ldap"], Package["nss-pam-ldapd"]],
	}

	service { "nslcd" :
		enable => true,
		ensure => true,
		require => File["/etc/nslcd.conf"],
		subscribe => File["/etc/nslcd.conf"]
	}

	replace {"enable_nss_ldap_passwd":
		file => "/etc/nsswitch.conf",
		pattern => "^passwd:.*(?!ldap)",
		replacement => "passwd:\t\tfiles ldap",
	}
	
	replace {"enable_nss_ldap_shadow":
		file => "/etc/nsswitch.conf",
		pattern => "^shadow:.*(?!ldap)",
		replacement => "shadow:\t\tfiles ldap",
	}
	
	replace {"enable_nss_ldap_group":
		file => "/etc/nsswitch.conf",
		pattern => "^group:.*(?!ldap)",
		replacement => "group:\t\tfiles ldap",
	}
}
