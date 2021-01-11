package main

import (
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Println(request.QueryStringParameters)

	fmt.Println(request)
	fmt.Print(request.HTTPMethod)

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprint("get-my-info"),
		StatusCode: http.StatusCreated,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
