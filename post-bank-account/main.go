package main

import (
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Println("post-bank-account called")
	fmt.Println(request)

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprint("post-bank-accounts"),
		StatusCode: http.StatusCreated,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
