from fastapi import APIRouter , Depends, HTTPException
from sqlalchemy.orm import Session
from ..database import get_db
import uuid

router = APIRouter(prefix="/payment", tags=["Payment"])

@router.post("generate-qr")
def generate_khqr(order_id: int, amount : float, db: Session = Depends(get_db)):
    # call Bakong API that create KHQR String and MD5 Hash 
    dummy_khqr_string = f"00020101021230580016a0000006770101110113000685500150303KHM5303840540{int(amount)}5802KH5909Merchant6007PhnomPenh6304"
    md5_hash = str(uuid.uuid4().hex)

    return {
        "order_id" : order_id,
        "amount" : amount,
        "qr_string" : dummy_khqr_string,
        "md5" : md5_hash,
        "status": "Pedding"

    }
@router.get("/check-status/{md5}")
def check_payment_status(md5:str):
    return {"status": "PAId" , "message": "Payment Scuccessfull"}