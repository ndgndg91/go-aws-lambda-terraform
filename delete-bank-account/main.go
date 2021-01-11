package main

import (
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Println("delete-bank-account called.")

	fmt.Println(request)

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprint("delete-bank-account"),
		StatusCode: http.StatusNoContent,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
