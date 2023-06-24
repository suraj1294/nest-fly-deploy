import { Exclude, classToPlain, instanceToPlain } from 'class-transformer';
import { IsEmail, IsNotEmpty, IsString } from 'class-validator';

export class CreateUserDto {
  @IsString()
  @IsNotEmpty()
  public name: string;

  @IsEmail()
  public email: string;
}

export class UserDto {
  id: number;
  name: string;
  email: string;

  @Exclude()
  isDeleted: boolean;

  @Exclude()
  createdAt: Date;

  @Exclude()
  updatedAt: Date;

  @Exclude()
  delete: Date;

  toJSON() {
    return instanceToPlain(this);
  }

  constructor(partial: Partial<UserDto>) {
    Object.assign(this, partial);
  }
}
