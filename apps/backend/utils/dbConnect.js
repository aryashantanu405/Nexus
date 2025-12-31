import mongoose from 'mongoose'
import dotenv from "dotenv"
dotenv.config()
let isConnected = false




export const dbConnect = async () => {
  if (isConnected) {
    console.log('Connection already established')
    return mongoose.connection
  }

  try {
    const conn = await mongoose.connect(process.env.MONGO_URI, {
    })

    isConnected = true
    console.log("successfully connected to db")

    return conn
  } catch (error) {
    console.error('MongoDB connection error:', error)
    process.exit(1)
  }
}
