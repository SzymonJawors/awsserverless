# AWS Serverless FastAPI App

A simple **FastAPI** application deployed as an **AWS Lambda** function (via Mangum), exposed through a **Lambda Function URL**, provisioned with **Terraform**, and automatically deployed using **GitHub Actions** with OIDC-based AWS authentication (no long-lived AWS keys stored in GitHub).

## Architecture

- **Application**: FastAPI app (`app/main.py`) wrapped with `Mangum` so it can run as an AWS Lambda handler.
- **Compute**: AWS Lambda (Python 3.13 runtime), exposed publicly via a Lambda Function URL (no API Gateway needed).
- **IaC**: Terraform manages the Lambda function, IAM roles/policies, the Function URL, and the GitHub OIDC identity provider.
- **State**: Terraform state is stored remotely in an S3 bucket (`backend.tf`).
- **CI/CD**: On every push to `main`, a GitHub Actions workflow:
  1. Checks out the repo.
  2. Authenticates to AWS via OIDC (assuming `GitHubActionsDeployRole` — no static credentials).
  3. Installs Python dependencies and packages the app into `terraform/api.zip`.
  4. Runs `terraform init` and `terraform apply` to deploy/update the infrastructure.

## Tech stack

| Layer            | Technology                          |
|-------------------|--------------------------------------|
| API framework      | FastAPI + Mangum                    |
| Compute            | AWS Lambda (Python 3.13)            |
| Public endpoint    | AWS Lambda Function URL             |
| Infrastructure     | Terraform                           |
| Remote state       | AWS S3                              |
| CI/CD              | GitHub Actions (OIDC to AWS)        |
| Region             | `eu-north-1`                        |

## Project structure

```
.
├── .github/workflows/deploy.yml   # CI/CD pipeline
├── app/
│   ├── main.py                    # FastAPI application
│   └── requirements.txt           # Python dependencies
└── terraform/
    ├── main.tf                    # Lambda function, IAM role, Function URL
    ├── oidc.tf                    # GitHub OIDC provider + deploy role
    ├── backend.tf                 # S3 remote state backend
    └── outputs.tf                 # Exposes the public API endpoint
```

## Deployment

Deployment is fully automated:

1. Push to the `main` branch.
2. GitHub Actions assumes the `GitHubActionsDeployRole` AWS IAM role via OIDC.
3. The app is packaged with its dependencies into `terraform/api.zip`.
4. Terraform applies the infrastructure and updates the Lambda function.
5. The public URL is available as the `api_endpoint` Terraform output.

### Manual deployment (local)

```bash
cd app
pip install -r requirements.txt -t .
zip -r ../terraform/api.zip .

cd ../terraform
terraform init
terraform apply
```

## Prerequisites for setup

- An AWS account with an S3 bucket for Terraform state (see `backend.tf`).
- A GitHub OIDC identity provider trust configured for your repository (see `oidc.tf`).
- Terraform >= 1.10.0

---

# Aplikacja AWS Serverless FastAPI

Prosta aplikacja **FastAPI** wdrożona jako funkcja **AWS Lambda** (za pomocą Mangum), udostępniona publicznie przez **Lambda Function URL**, z infrastrukturą zdefiniowaną w **Terraform** i automatycznym wdrażaniem przez **GitHub Actions** z uwierzytelnianiem OIDC do AWS (bez przechowywania stałych kluczy AWS w GitHubie).

## Architektura

- **Aplikacja**: aplikacja FastAPI (`app/main.py`) opakowana przez `Mangum`, dzięki czemu może działać jako handler AWS Lambda.
- **Warstwa obliczeniowa**: AWS Lambda (środowisko Python 3.13), udostępniona publicznie przez Lambda Function URL (bez potrzeby API Gateway).
- **IaC**: Terraform zarządza funkcją Lambda, rolami/politykami IAM, adresem URL funkcji oraz dostawcą tożsamości GitHub OIDC.
- **Stan**: stan Terraform jest przechowywany zdalnie w buckecie S3 (`backend.tf`).
- **CI/CD**: przy każdym pushu do gałęzi `main` workflow GitHub Actions:
  1. Pobiera repozytorium.
  2. Uwierzytelnia się w AWS za pomocą OIDC (przyjmując rolę `GitHubActionsDeployRole` — bez statycznych poświadczeń).
  3. Instaluje zależności Pythona i pakuje aplikację do `terraform/api.zip`.
  4. Uruchamia `terraform init` oraz `terraform apply`, aby wdrożyć/zaktualizować infrastrukturę.

## Stos technologiczny

| Warstwa            | Technologia                          |
|----------------------|--------------------------------------|
| Framework API         | FastAPI + Mangum                    |
| Warstwa obliczeniowa  | AWS Lambda (Python 3.13)            |
| Publiczny endpoint    | AWS Lambda Function URL             |
| Infrastruktura        | Terraform                           |
| Zdalny stan           | AWS S3                              |
| CI/CD                 | GitHub Actions (OIDC do AWS)        |
| Region                | `eu-north-1`                        |

## Struktura projektu

```
.
├── .github/workflows/deploy.yml   # Pipeline CI/CD
├── app/
│   ├── main.py                    # Aplikacja FastAPI
│   └── requirements.txt           # Zależności Pythona
└── terraform/
    ├── main.tf                    # Funkcja Lambda, rola IAM, Function URL
    ├── oidc.tf                    # Dostawca OIDC GitHub + rola wdrożeniowa
    ├── backend.tf                 # Zdalny backend stanu w S3
    └── outputs.tf                 # Udostępnia publiczny adres API
```

## Wdrożenie

Wdrożenie jest w pełni zautomatyzowane:

1. Push do gałęzi `main`.
2. GitHub Actions przyjmuje rolę IAM `GitHubActionsDeployRole` przez OIDC.
3. Aplikacja jest pakowana wraz z zależnościami do `terraform/api.zip`.
4. Terraform wdraża infrastrukturę i aktualizuje funkcję Lambda.
5. Publiczny adres URL jest dostępny jako output Terraform `api_endpoint`.

### Wdrożenie ręczne (lokalne)

```bash
cd app
pip install -r requirements.txt -t .
zip -r ../terraform/api.zip .

cd ../terraform
terraform init
terraform apply
```

## Wymagania wstępne

- Konto AWS z bucketem S3 na stan Terraform (zobacz `backend.tf`).
- Skonfigurowany dostawca tożsamości GitHub OIDC zaufany dla Twojego repozytorium (zobacz `oidc.tf`).
- Terraform >= 1.10.0
