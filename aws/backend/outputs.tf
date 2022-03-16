output "apigateway_url" {
  value = aws_apigatewayv2_stage.deployment.invoke_url
}

output "apigateway_analyze_route" {
  value = "${aws_apigatewayv2_stage.deployment.invoke_url}/analyze"
}
