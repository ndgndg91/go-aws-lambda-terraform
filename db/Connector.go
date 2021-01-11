package db

import "github.com/jmoiron/sqlx"

func GetConnection() (*sqlx.DB, error) {
	return sqlx.Connect("mysql", "bankda:bankda@(bank-account-manager-test-201223-instance-1.crtxqczk1noq.ap-northeast-2.rds.amazonaws.com:3306)/passbook")
}
