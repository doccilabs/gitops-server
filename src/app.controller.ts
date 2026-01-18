import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';
import { ConfigService } from '@nestjs/config';

@Controller()
export class AppController {
  constructor(
    private readonly appService: AppService,
    private readonly configService: ConfigService,
  ) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  @Get(`/health`)
  healthCheck(): string {
    return 'health';
  }

  @Get(`/test`)
  test(): string {
    return `test5`;
  }

  @Get('/env-test')
  environmentTest(): string {
    const envString = this.configService.get<string>('example-key');

    if (envString === undefined) {
      return 'undefined env!';
    }

    return envString;
  }
}
