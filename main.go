package main

import (
	"fmt"
	"net/http"

	"github.com/aws/aws-lambda-go/events"
	"github.com/aws/aws-lambda-go/lambda"
)

func Handler(request events.APIGatewayProxyRequest) (events.APIGatewayProxyResponse, error) {
	fmt.Println(request.QueryStringParameters)
	username := request.QueryStringParameters["username"]
	email := request.QueryStringParameters["email"]

	fmt.Println(username)
	fmt.Println(email)
	fmt.Println(request)

	return events.APIGatewayProxyResponse{
		Body:       fmt.Sprint("Resource is created."),
		StatusCode: http.StatusCreated,
	}, nil
}

func main() {
	lambda.Start(Handler)
}
