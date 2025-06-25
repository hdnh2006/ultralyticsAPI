# Build:
# docker build -t hdnh2006/ultralyticsapi .

# This builds an image similar to ultralytics/ultralytics:latest image on DockerHub https://hub.docker.com/r/ultralytics/ultralytics
# Image is CUDA-optimized for single/multi-GPU training and inference

# Start FROM last ultralytics image https://hub.docker.com/r/ultralytics/ultralytics
FROM ultralytics/ultralytics

# Create working directory
WORKDIR /usr/src/app

# Copy contents # git permission issues inside container
COPY . /usr/src/app  

# Install pip packages
RUN python3 -m pip install --upgrade pip wheel
RUN pip install --no-cache -r requirements.txt

# Run predict_api.py with TensorRT
# CMD ["sh", "-c", "yolo export model=yolo11s.pt format="engine" imgsz=640 simplify=True device=0 batch=1 half=True && python predict_api.py --weights ${WEIGHTS:-weights/yolo11s/best.pt} --imgsz ${IMGSZ:-640} --port ${PORT:-5000} --half True"]
# docker run --runtime nvidia --gpus all --ipc=host --network="host" -d --name ultralyticsapi hdnh2006/ultralyticsapi yolo export model=yolo11s.pt format="engine" imgsz=640 simplify=True device=0 batch=1 half=True && python predict_api.py --weights weights/yolo11s/best.engine --imgsz 640 --port 5000 --half True

# Run predict_api.py with OpenVINO
# CMD ["sh", "-c", "yolo export model=yolo11s.pt format="openvino" imgsz=640 simplify=True device=0 batch=1 half=True && python predict_api.py --weights ${WEIGHTS:-weights/yolo11s/best_openvino_model} --imgsz ${IMGSZ:-640} --port ${PORT:-5000} --half True --device cpu"]
# docker run --ipc=host --network="host" -d --name ultralyticsapi hdnh2006/ultralyticsapi yolo export model=yolo11s.pt format="openvino" imgsz=640 simplify=True device=0 batch=1 half=True && python predict_api.py --weights weights/yolo11s/best_openvino_model --imgsz 640 --port 5000 --half True --device cpu
