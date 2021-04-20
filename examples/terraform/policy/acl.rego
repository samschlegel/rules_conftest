package main

acl_is_public(acl) {
    public_acls = {"public-read", "public-read-write", "website"}
    public_acls[acl]
}

deny[msg] {
	rule := input.resource.aws_s3_bucket[name]
	rule.tags["Scope"] == "PCI"
    acl_is_public(rule.acl)
    msg = sprintf("PCI Scoped bucket %s has a public ACL: %s", [name, rule.acl])
}
