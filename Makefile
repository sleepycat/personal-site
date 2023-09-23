PROJECT=personal-site-398401
BUCKET_NAME=mikewilliamsondevstatic
CERT_NAME=personalsite-tls
DOMAIN_NAME=mikewilliamson.dev

.PHONY: bucket
bucket:
	gcloud storage buckets create gs://$(BUCKET_NAME) --default-storage-class=NEARLINE --location=northamerica-northeast1 --uniform-bucket-level-access

.PHONY: html
html:
	gcloud storage cp -j *.html gs://$(BUCKET_NAME)/
	gcloud storage buckets update gs://$(BUCKET_NAME) --web-main-page-suffix=index.html --web-error-page=404.html

.PHONY: icons
icons:
	gcloud storage cp -n -r icons gs://$(BUCKET_NAME)/

.PHONY: public
public:
	gcloud storage buckets add-iam-policy-binding  gs://$(BUCKET_NAME) --member=allUsers --role=roles/storage.objectViewer

.PHONY: certficate
certificate:
	gcloud beta compute ssl-certificates create $(CERT_NAME) --project=$(PROJECT) --global --description="$(DOMAIN_NAME) certificate" --domains=$(DOMAIN_NAME)

.PHONY: errorpage
errorpage:
	gcloud storage buckets update gs://$(BUCKET_NAME) --web-main-page-suffix=index.html --web-error-page=404.html

.PHONY: status
status:
	gcloud compute ssl-certificates describe $(CERT_NAME) --global --format="get(name,managed.status)"
	gcloud compute ssl-certificates describe $(CERT_NAME) --global --format="get(managed.domainStatus)"
