import { APIGatewayProxyEvent, APIGatewayProxyResult } from 'aws-lambda';
import { MetricUnit, Metrics } from '@aws-lambda-powertools/metrics';
import { getHeaders, errorHandler, logger, schemaValidator } from '@shared';
import { Tracer } from '@aws-lambda-powertools/tracer';
import { captureLambdaHandler } from '@aws-lambda-powertools/tracer/middleware';
import { injectLambdaContext } from '@aws-lambda-powertools/logger/middleware';
import { logMetrics } from '@aws-lambda-powertools/metrics/middleware';
import middy from '@middy/core';

import { CreateProductDto } from '@dto/create-product';
import { ProductDto } from '@dto/product';
import { ValidationError } from '@errors/validation-error';
import { createProductUseCase } from '@use-cases/create-product';
import { schema } from './create-product.schema';
import httpErrorHandler from '@middy/http-error-handler';
import { config } from '@config';

const tracer = new Tracer();
const metrics = new Metrics();

const stage = config.get('stage');

export const createProduct = async ({
  body,
}: APIGatewayProxyEvent): Promise<APIGatewayProxyResult> => {
  try {
    if (!body) throw new ValidationError('no payload body');

    const product = JSON.parse(body) as CreateProductDto;
    logger.info('here');
    schemaValidator(schema, product);
    logger.info('here2');
    const created: ProductDto = await createProductUseCase(product);

    metrics.addMetric('SuccessfulCreateProduct', MetricUnit.Count, 1);

    return {
      statusCode: 200,
      body: JSON.stringify(created),
      headers: getHeaders(stage),
    };
  } catch (error) {
    let errorMessage = 'Unknown error';
    if (error instanceof Error) errorMessage = error.message;
    logger.error(errorMessage);

    metrics.addMetric('CreateProductError', MetricUnit.Count, 1);

    return errorHandler(error);
  }
};

export const handler = middy(createProduct)
  .use(injectLambdaContext(logger))
  .use(captureLambdaHandler(tracer))
  .use(logMetrics(metrics))
  .use(httpErrorHandler());
