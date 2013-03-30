
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
		require => Package["nss-pam-ldapd"],
	}

	service { "nslcd" :
		enable => true,
		ensure => true,
		require => File["/etc/nslcd.conf"],
		subscribe => File["/etc/nslcd.conf"]
	}
}
