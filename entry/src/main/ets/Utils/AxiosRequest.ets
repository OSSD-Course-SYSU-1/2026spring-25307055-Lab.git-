import axios, { AxiosError, AxiosInstance, AxiosRequestConfig,
  AxiosResponse, InternalAxiosRequestConfig } from '@ohos/axios'

const instance: AxiosInstance = axios.create({
  baseURL: 'http://192.168.180.182:8080',
  timeout: 10000,
  headers: {
    'Content-Type': 'application/json'
  }
})

export interface ApiResponse<T> {
  code: number
  msg: string
  data: T
}

export class NetworkError extends Error {
  public isNetworkError: boolean = true

  constructor() {
    super('网络连接失败，已切换至离线模式')
    this.name = 'NetworkError'
  }
}

// 不含 any 的错误接口，代替 AxiosError（后者有 request?: any，ArkTS 禁止）
export interface CheckableError {
  response?: Object
}

// 拦截器仅添加一次
instance.interceptors.request.use((config: InternalAxiosRequestConfig) => {
  return config
}, (error: AxiosError) => {
  return Promise.reject(error)
})

instance.interceptors.response.use((response: AxiosResponse) => {
  if (response.data.code === 200) {
    console.log(response.data.msg)
  }
  return response.data
}, (error: AxiosError) => {
  console.log("AxiosError", JSON.stringify(error.response))
  return Promise.reject(error)
})

export default function request<T>(config: AxiosRequestConfig): Promise<ApiResponse<T>> {
  return instance(config) as Promise<ApiResponse<T>>
}

/**
 * 判断错误是否因网络不可达（服务器无响应）
 * 统一在此处转换，避免各模块重复 as CheckableError
 */
export function isNetworkError(err: Object): boolean {
  const ce = err as CheckableError
  return (ce.response === undefined || ce.response === null)
}
